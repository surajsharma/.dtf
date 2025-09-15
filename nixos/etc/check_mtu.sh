#!/usr/bin/env bash
IFACE="wlan0"
TARGET="8.8.8.8"

# Start from high (1472 bytes payload = 1500 MTU)
SIZE=1472
LOW=1200
HIGH=1472

while [ $LOW -le $HIGH ]; do
    MID=$(( (LOW + HIGH)/2 ))
    if ping -c1 -W1 -M do -s $MID $TARGET >/dev/null 2>&1; then
        LOW=$((MID + 1))   # can go bigger
        MTU=$((MID + 28))
    else
        HIGH=$((MID - 1))  # must go smaller
    fi
done

echo "Detected MTU: $MTU"
ip link set dev "$IFACE" mtu "$MTU"
