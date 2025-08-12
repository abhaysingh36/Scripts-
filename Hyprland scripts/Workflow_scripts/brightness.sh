#!/bin/bash

# Path to brightnessctl or another brightness control tool
BRIGHTNESS=$(brightnessctl | grep -oP '(?<=Current brightness: )\d+' | head -1)
MAX_BRIGHTNESS=$(brightnessctl | grep -oP '(?<=Max brightness: )\d+' | head -1)
PERCENT=$(( ($BRIGHTNESS * 100) / $MAX_BRIGHTNESS ))

# Handle arguments for brightness up/down
if [ "$1" = "up" ]; then
  brightnessctl set +5%
  BRIGHTNESS=$(brightnessctl | grep -oP '(?<=Current brightness: )\d+' | head -1)
  PERCENT=$(( ($BRIGHTNESS * 100) / $MAX_BRIGHTNESS ))
elif [ "$1" = "down" ]; then
  brightnessctl set 5%-
  BRIGHTNESS=$(brightnessctl | grep -oP '(?<=Current brightness: )\d+' | head -1)
  PERCENT=$(( ($BRIGHTNESS * 100) / $MAX_BRIGHTNESS ))
fi

# Output JSON
echo "{\"text\": \"$PERCENT% \",\"tooltip\": \"Brightness: $PERCENT%\"}"
