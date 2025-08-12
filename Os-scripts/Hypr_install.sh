#!/bin/bash

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print messages
print_message() {
    echo -e "${2}[*] ${1}${NC}"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_message "Do not run this script as root. Run it as a regular user." "${RED}"
    exit 1
fi

# Check if system is Arch-based
if ! command -v pacman &> /dev/null; then
    print_message "This script is designed for Arch-based systems. Please adapt for your distribution." "${RED}"
    exit 1
fi

# Update system and AUR to avoid version conflicts
print_message "Updating system and AUR packages..." "${YELLOW}"
sudo pacman -Syu --noconfirm || {
    print_message "Failed to update system packages. Check your internet or sudo privileges." "${RED}"
    exit 1
}
yay -Syu --noconfirm || {
    print_message "Failed to update AUR packages. Check your AUR setup or internet connection." "${RED}"
    exit 1
}
print_message "System and AUR updated successfully." "${GREEN}"

# Check for required tools
print_message "Checking for required tools..." "${YELLOW}"
for tool in git pacman yay; do
    if ! command -v "$tool" &> /dev/null; then
        print_message "$tool is not installed. Installing $tool..." "${YELLOW}"
        if [ "$tool" = "yay" ]; then
            sudo pacman -S --needed git base-devel || {
                print_message "Failed to install dependencies for yay." "${RED}"
                exit 1
            }
            git clone https://aur.archlinux.org/yay.git /tmp/yay
            cd /tmp/yay
            makepkg -si --noconfirm || {
                print_message "Failed to install yay. Check for errors and try again." "${RED}"
                exit 1
            }
            cd -
            rm -rf /tmp/yay
        else
            print_message "$tool is required but not installed. Please install it manually." "${RED}"
            exit 1
        fi
    fi
done

# Backup existing configurations
print_message "Backing up existing Hyprland and Waybar configurations..." "${YELLOW}"
[ -d ~/.config/hypr ] && mv ~/.config/hypr ~/.config/hypr.bak-$(date +%F)
[ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar.bak-$(date +%F)
print_message "Backups created at ~/.config/hypr.bak-* and ~/.config/waybar.bak-*" "${GREEN}"

# Uninstall existing Hyprland and Waybar packages
print_message "Uninstalling existing Hyprland and Waybar packages..." "${YELLOW}"
sudo pacman -Rns --noconfirm hyprland waybar 2>/dev/null || print_message "No pacman packages to remove." "${YELLOW}"
yay -Rns --noconfirm hyprland-git waybar-git 2>/dev/null || print_message "No AUR packages to remove." "${YELLOW}"
print_message "Old packages removed." "${GREEN}"

# Clear package cache
print_message "Clearing package cache (removing untracked packages)..." "${YELLOW}"
sudo pacman -Sc --noconfirm || print_message "Failed to clear pacman cache." "${YELLOW}"
yay -Sc --noconfirm || print_message "Failed to clear yay cache." "${YELLOW}"
print_message "Package cache cleared." "${GREEN}"

# Attempt to install stable versions
print_message "Installing Hyprland and Waybar (stable versions)..." "${YELLOW}"
if ! yay -S --noconfirm hyprland waybar 2>/dev/null; then
    print_message "Stable installation failed. Attempting AUR development versions (hyprland-git, waybar-git)..." "${YELLOW}"
    if ! yay -S --noconfirm hyprland-git waybar-git 2>/dev/null; then
        print_message "Failed to install Hyprland or Waybar. Check dependency conflicts or run 'yay -S hyprland waybar' manually to resolve." "${RED}"
        print_message "Common fixes: Update system, install missing dependencies (e.g., hyprutils), or use '--overwrite '*''." "${YELLOW}"
        exit 1
    fi
    print_message "Hyprland and Waybar (development versions) installed successfully." "${GREEN}"
else
    print_message "Hyprland and Waybar (stable versions) installed successfully." "${GREEN}"
fi

# Create basic Hyprland configuration
print_message "Setting up basic Hyprland configuration..." "${YELLOW}"
mkdir -p ~/.config/hypr
cat << EOF > ~/.config/hypr/hyprland.conf
# Basic Hyprland configuration
monitor=,preferred,auto,1

# Input settings
input {
    kb_layout = us
    follow_mouse = 1
}

# General settings
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
}

# Decorations
decoration {
    rounding = 10
    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# Launch Waybar
exec-once = waybar
EOF
print_message "Hyprland configuration created at ~/.config/hypr/hyprland.conf" "${GREEN}"

# Create basic Waybar configuration
print_message "Setting up basic Waybar configuration..." "${YELLOW}"
mkdir -p ~/.config/waybar
cat << EOF > ~/.config/waybar/config
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["hyprland/window"],
    "modules-right": ["clock"],
    "clock": {
        "format": "{:%Y-%m-%d %H:%M}"
    }
}
EOF
cat << EOF > ~/.config/waybar/style.css
* {
    font-family: monospace;
    font-size: 14px;
}
window#waybar {
    background: rgba(0, 0, 0, 0.8);
    color: white;
}
EOF
print_message "Waybar configuration created at ~/.config/waybar/" "${GREEN}"

# Set permissions for configuration files
chmod -R 600 ~/.config/hypr/* ~/.config/waybar/*
chmod -R 700 ~/.config/hypr ~/.config/waybar
print_message "Permissions set for configuration files." "${GREEN}"

# Check for display manager
if ! command -v sddm &> /dev/null; then
    print_message "No display manager (e.g., sddm) detected. You may need to install one or start Hyprland manually with 'Hyprland' from a TTY." "${YELLOW}"
fi

# Instructions for the user
print_message "Installation complete! To start Hyprland, log out and select Hyprland from your display manager, or run 'Hyprland' from a TTY." "${GREEN}"
print_message "Backups of old configurations are available at ~/.config/hypr.bak-* and ~/.config/waybar.bak-*." "${YELLOW}"
print_message "If Waybar fails to load, ensure a monospace font (e.g., ttf-dejavu) is installed: 'sudo pacman -S ttf-dejavu'." "${YELLOW}"
