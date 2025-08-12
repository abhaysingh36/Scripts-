#!/bin/bash

# Get the list of active workspaces (sorted)
workspaces=($(hyprctl workspaces -j | jq -r 'sort_by(.id) | .[].id'))

# Get the currently active workspace
current_ws=$(hyprctl activeworkspace -j | jq '.id')

# Find the index of the current workspace
index=-1
for i in "${!workspaces[@]}"; do
    if [[ "${workspaces[$i]}" == "$current_ws" ]]; then
        index=$i
        break
    fi
done

# Determine the next workspace (loop back if at the last)
if [[ $index -eq -1 ]]; then
    exit 1  # Exit if the current workspace is not found
fi

if [[ $((index + 1)) -ge ${#workspaces[@]} ]]; then
    next_ws=${workspaces[0]}  # Loop to the first workspace
else
    next_ws=${workspaces[$((index + 1))]}
fi

# Move to the next active workspace
hyprctl dispatch workspace "$next_ws"

