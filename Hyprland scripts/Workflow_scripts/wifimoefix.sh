#!/bin/bash
sudo ip link set wlan0 down
sudo iwconfig wlan0 mode managed
sudo ip link set wlan0 up
sudo rfkill unblock all
sudo nmcli radio wifi on

