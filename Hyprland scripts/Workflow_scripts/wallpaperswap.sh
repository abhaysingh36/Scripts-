#!/bin/bash

# Define wallpaper directory
WALLPAPER_DIR="$HOME/.config/backgrounds"

# Ensure Hyprpaper is running
if ! pgrep -x "hyprpaper" > /dev/null; then
    echo "Hyprpaper is not running. Starting it now..."
    hyprpaper &
    sleep 1  # Allow some time for it to start
fi

# Find wallpapers (avoiding empty array issue)
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)

# Ensure the directory has valid wallpapers
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Cache file to track last wallpaper
CACHE_FILE="/tmp/hyprpaper_last_wallpaper"

# Read last wallpaper index
if [[ -f "$CACHE_FILE" ]]; then
    LAST_INDEX=$(cat "$CACHE_FILE")
else
    LAST_INDEX=-1
fi

# Compute next wallpaper index (loop back to 0 when reaching the end)
NEXT_INDEX=$(( (LAST_INDEX + 1) % ${#WALLPAPERS[@]} ))
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Unload previous wallpaper only if valid
if [[ $LAST_INDEX -ge 0 && $LAST_INDEX -lt ${#WALLPAPERS[@]} ]]; then
    PREV_WALLPAPER="${WALLPAPERS[$LAST_INDEX]}"
    hyprctl hyprpaper unload "$PREV_WALLPAPER"
fi

# Preload and apply wallpaper to all active monitors
hyprctl hyprpaper preload "$NEXT_WALLPAPER"
sleep 0.2  # Ensure preloading completes

# Get active monitors and apply wallpaper
hyprctl monitors | awk '/Monitor/ {print $2}' | while read -r MONITOR; do
    hyprctl hyprpaper wallpaper "$MONITOR,$NEXT_WALLPAPER"
done

# Save the new index
echo "$NEXT_INDEX" > "$CACHE_FILE"

echo "Wallpaper changed to: $NEXT_WALLPAPER for all monitors"

