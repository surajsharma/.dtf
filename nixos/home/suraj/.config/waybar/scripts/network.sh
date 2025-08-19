#!/bin/bash

# Check if connected to WiFi
WIFI_SSID=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d: -f2)
WIFI_SIGNAL=$(nmcli -t -f active,signal dev wifi | egrep '^yes' | cut -d: -f2)

# Check if connected via ethernet
ETHERNET=$(nmcli -t -f device,state dev | grep ethernet | grep connected | cut -d: -f1)

if [ -n "$WIFI_SSID" ]; then
  # Connected to WiFi - convert to uppercase
  WIFI_UPPER=$(echo "$WIFI_SSID" | tr '[:lower:]' '[:upper:]')
  echo "$WIFI_UPPER ($WIFI_SIGNAL%)"
elif [ -n "$ETHERNET" ]; then
  # Connected via ethernet - convert to uppercase
  ETH_UPPER=$(echo "$ETHERNET" | tr '[:lower:]' '[:upper:]')
  echo "$ETH_UPPER"
else
  # Not connected
  echo "DISCONNECTED"
fi
