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

# Check for required tools
print_message "Checking for required tools..." "${YELLOW}"
for tool in git pacman yay; do
    if ! command -v "$tool" &> /dev/null; then
        print_message "$tool is not installed. Installing $tool..." "${YELLOW}"
        if [ "$tool" = "yay" ]; then
            sudo pacman -S --needed git base-devel
            git clone https://aur.archlinux.org/yay.git /tmp/yay
            cd /tmp/yay
            makepkg -si --noconfirm
            cd -
        else
            print_message "$tool is required but not installed. Please install it manually." "${RED}"
            exit 1
        fi
    fi
done

# Remove existing Hyprland and Waybar configurations
print_message "Removing existing Hyprland and Waybar configurations..." "${YELLOW}"
rm -rf ~/.config/hypr ~/.config/waybar
print_message "Old configurations removed." "${GREEN}"

# Uninstall existing Hyprland and Waybar packages
print_message "Uninstalling existing Hyprland and Waybar packages..." "${YELLOW}"
sudo pacman -Rns --noconfirm hyprland waybar || true
yay -Rns --noconfirm hyprland-git waybar-git || true
print_message "Old packages removed." "${GREEN}"

# Clear pacman and yay cache to ensure fresh install
print_message "Clearing package cache..." "${YELLOW}"
sudo pacman -Scc --noconfirm
yay -Scc --noconfirm
print_message "Package cache cleared." "${GREEN}"

# Install Hyprland and Waybar
print_message "Installing Hyprland and Waybar..." "${YELLOW}"
yay -S --noconfirm hyprland waybar
print_message "Hyprland and Waybar installed successfully." "${GREEN}"

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
chmod -R 700 ~/.config/hypr ~/.config/waybar
print_message "Permissions set for configuration files." "${GREEN}"

# Instructions for the user
print_message "Installation complete! To start Hyprland, log out and select Hyprland from your display manager, or run 'Hyprland' from a TTY." "${GREEN}"
print_message "You may need to install a display manager (e.g., sddm) or configure your system to start Hyprland manually." "${YELLOW}"
