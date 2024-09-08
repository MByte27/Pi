#!/bin/bash

# ntfy server vars
NTFY_SERVER="http://100.103.12.107:90"
CHANNEL="ntPi3"

# send function
send_ntfy() {
  curl -H "Title: $CHANNEL: Update System" -H "Priority: $1" -H ta:card_index_dividers -d "$2" "$NTFY_SERVER/$CHANNEL"
}

# update begin -> print update log
send_ntfy "2" "Looking for updates .."
sudo apt update > /tmp/apt_update.log

# check upgradeables from temp log
UPGRADE_COUNT=$(grep "packages can be upgraded." /tmp/apt_update.log | awk '{print $1}')

# if UPGRADE_COUNT empty, set 0
UPGRADE_COUNT=${UPGRADE_COUNT:-0}

if [ "$UPGRADE_COUNT" -gt 0 ]; then
  # list upgradeable in notification
  UPGRADE_LIST=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | awk '{print $1}')
  send_ntfy "3" "Upgradeable:\n$UPGRADE_LIST"

  # upgrade exec -> print upgrade log
  sudo apt full-upgrade -y > /tmp/apt_upgrade.log

  send_ntfy "3" "Upgrade completed. $UPGRADE_COUNT upgraded packages."
else
  send_ntfy "2" "Everything's up to date."
fi

sudo rm -f /tmp/apt_upgrade.log
sudo rm -f /tmp/apt_upgrade.log
