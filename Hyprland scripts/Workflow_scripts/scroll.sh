#!/bin/bash
direction=$1
if [ "$direction" = "up" ]; then
    warpd -s -w  # Simulate scroll up (adjust keybinding if needed)
elif [ "$direction" = "down" ]; then
    warpd -s -s  # Simulate scroll down
fi
