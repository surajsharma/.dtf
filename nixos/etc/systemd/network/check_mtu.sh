#!/run/current-system/sw/bin/bash
set -euo pipefail

IFACE="wlan0"
TARGET="8.8.8.8"

# Full paths for NixOS
PING="/run/current-system/sw/bin/ping"
IP="/run/current-system/sw/bin/ip"

SIZE=1472
LOW=1200
HIGH=1472
MTU=0 # initialize to something safe

while [ $LOW -le $HIGH ]; do
  MID=$(((LOW + HIGH) / 2))
  if $PING -c1 -W1 -M do -s $MID $TARGET >/dev/null 2>&1; then
    LOW=$((MID + 1))  # can try bigger
    MTU=$((MID + 28)) # store candidate
  else
    HIGH=$((MID - 1)) # must try smaller
  fi
done

if [ $MTU -eq 0 ]; then
  echo "ERROR: failed to determine a working MTU, defaulting to 1400"
  MTU=1400
fi

echo "Detected MTU: $MTU"
$IP link set dev "$IFACE" mtu "$MTU"
