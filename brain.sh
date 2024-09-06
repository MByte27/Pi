#!/bin/bash

# ################## PRELIMINARY FUNCTION AND CODE ##################

NTFY_SERVER="http://100.103.12.107:90"
CHANNEL="ntPi3"  # change into ntPi0 when importing into Raspberry Pi 0

# Send function
send_ntfy() {
  curl -H "Title: $CHANNEL: Update System" -H "Priority: $1" -d "$2" "$NTFY_SERVER/$CHANNEL"
}
# ################## ################## ##################

# ################## UPDATES ##################

# Delete old logs
sudo rm -f /tmp/apt_upgrade.log
sudo rm -f /tmp/apt_upgrade.log

# Initialising update process: look for updates, low priority (No push)
send_ntfy "2" "Scanning for updates .."
# Store update log in temp file
sudo apt update > /tmp/apt_update.log

# Check upgradeables from temp log
UPGRADE_COUNT=$(grep "packages can be upgraded." /tmp/apt_update.log | awk '{print $1}')

# If UPGRADE_COUNT empty, set to 0
UPGRADE_COUNT=${UPGRADE_COUNT:-0}

if [ "$UPGRADE_COUNT" -gt 0 ]; then
  # List upgradeable in notification
  UPGRADE_LIST=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | awk '{print $1}')
  send_ntfy "3" "Upgradeable:\n$UPGRADE_LIST"
  
  # Do full-upgrade and store to log
  sudo apt full-upgrade -y > /tmp/apt_upgrade.log

  # Send notification about how many pkgs have been updated. Priority increased (Default push)
  send_ntfy "3" "Upgrade completed. $UPGRADE_COUNT upgraded packages."
else
  # Priority 2 (No notification)
  send_ntfy "2" "Everything up to date."
fi
