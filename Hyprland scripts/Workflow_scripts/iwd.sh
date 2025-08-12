#!/bin/bash

DEVICE=$(iwctl device list | awk '/station/ {print $2}' | head -n1)

if [[ -z "$DEVICE" ]]; then
  echo '{"text": "󰤭  No Device", "tooltip": "No WiFi device found"}'
  exit 0
fi

INFO=$(iwctl station "$DEVICE" show)

STATE=$(echo "$INFO" | grep -E "^\s*State\s" | awk '{print $NF}')
SSID=$(echo "$INFO" | grep -E "^\s*Connected network\s" | awk '{$1=""; $2=""; print $0}' | sed 's/^ *//')

if [[ "$STATE" == "connected" && -n "$SSID" ]]; then
  echo "{\"text\": \"󰤨  $SSID\", \"tooltip\": \"Connected to $SSID\"}"
else
  echo '{"text": "󰤭  Disconnected", "tooltip": "Not connected to WiFi"}'
fi

