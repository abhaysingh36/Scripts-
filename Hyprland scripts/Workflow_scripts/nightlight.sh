#!/bin/bash

STATE_FILE="/tmp/nightlight_state"

# Detect Wayland compositor
if pgrep -x "Hyprland" >/dev/null || pgrep -x "sway" >/dev/null; then
    METHOD="wlsunset"
elif pgrep -x "gnome-shell" >/dev/null; then
    METHOD="gnome"
else
    echo "Unsupported compositor!"
    exit 1
fi

# Toggle Night Mode
if [[ -f "$STATE_FILE" && $(cat "$STATE_FILE") == "on" ]]; then
    if [[ "$METHOD" == "wlsunset" ]]; then
        pkill wlsunset  # Stop night mode
    elif [[ "$METHOD" == "gnome" ]]; then
        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
    fi
    echo "off" > "$STATE_FILE"
    notify-send "Night Light Disabled"
else
    if [[ "$METHOD" == "wlsunset" ]]; then
        wlsunset -T 3500 -t 2000 &  # Enable night mode
    elif [[ "$METHOD" == "gnome" ]]; then
        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    fi
    echo "on" > "$STATE_FILE"
    notify-send "Night Light Enabled"
fi

