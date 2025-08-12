#!/bin/bash

HDMI_MONITOR="HDMI-A-1"
INTERNAL_MONITOR="eDP-1"

while true; do
    if hyprctl monitors | awk '/HDMI-A-1/ { found=1 } END { exit !found }'; then
        echo "HDMI detected. Switching to external monitor..."
        hyprctl keyword monitor "$HDMI_MONITOR, preferred, auto, 1"
#        hyprctl keyword monitor "$INTERNAL_MONITOR, disable"
    else
        echo "No HDMI detected. Using internal display..."
        hyprctl keyword monitor "$INTERNAL_MONITOR, preferred, auto, 1"
    fi
    sleep 5  # Check every 5 seconds
done

