#!/bin/bash

log="/tmp/hypr_debug.log"
echo "---- Run ----" >> "$log"

# Get active window class
active_window=$(hyprctl activewindow | grep "class:" | awk '{print $2}')
echo "Active window class: $active_window" >> "$log"

# Default fallback
dir="$HOME"

# If it's Nautilus
if [[ "$active_window" == "org.gnome.Nautilus" ]]; then
    echo "Trying clipboard fallback" >> "$log"

    # Activate Nautilus first (optional but helps if focus is off)
    hyprctl dispatch focuswindow "$active_window"
    sleep 0.2

    # Simulate Ctrl+L and Ctrl+C
    hyprctl dispatch exec "wtype -M ctrl -k l -m ctrl"
    sleep 0.3
    hyprctl dispatch exec "wtype -M ctrl -k c -m ctrl"
    sleep 0.3

    # Get clipboard contents
    dir=$(wl-paste)
    echo "Clipboard raw: $dir" >> "$log"

    # Clean the path
    [[ -f "$dir" ]] && dir=$(dirname "$dir")
    dir=$(echo "$dir" | sed -e 's|^file://||' -e 's/%20/ /g')
fi

# Final fallback
if [[ -z "$dir" || ! -d "$dir" ]]; then
    echo "Invalid dir: $dir, using $HOME instead." >> "$log"
    dir="$HOME"
fi

echo "Final dir: $dir" >> "$log"

# Launch terminal
kitty --working-directory="$dir" &

