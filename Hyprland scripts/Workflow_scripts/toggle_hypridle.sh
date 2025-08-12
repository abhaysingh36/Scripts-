#!/bin/bash
# File: ~/.config/hypr/scripts/toggle_hypridle.sh

# Check if hypridle is running
if pgrep -x "hypridle" > /dev/null; then
    # Hypridle is running, so kill it to disable autolock
    pkill -x hypridle
    echo '{"text": "🔓", "tooltip": "Autolock Disabled", "class": "autolock-disabled"}'
else
    # Hypridle is not running, so start it to enable autolock
    hypridle &
    echo '{"text": "🔒", "tooltip": "Autolock Enabled", "class": "autolock-enabled"}'
fi
