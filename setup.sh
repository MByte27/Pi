#!/bin/bash

# ----------- preliminary update of all installed packages -----------
sudo apt update
sudo apt full-upgrade -y
# ----------- ----------- ----------- ----------- ----------- --------

# ----------- install required packages -----------
sudo apt install fio docker-compose lsof python3-pip python3-venv -y
# ----------- ----------- ----------- ----------- -

src="/home/pietro/Pi"
is_Zero=false

# ----------- Find out if model is Pi Zero -----------
if grep -q "Raspberry Pi Zero" /proc/device-tree/model; then
  echo "Device is Pi Zero. Skipping Uptime Kuma.." # Uptime Kuma is incompatible with v6 kernel
  is_Zero=true
fi
# ----------- ----------- ----------- ----------- ----

# Loop over folders in the source directory
for folder in "$src"/*; do
    if [ -d "$folder" ]; then
        dest="$folder"

        # Loop over items inside each folder
        for item in "$folder"/*; do
            # Check if the item is "uptime-kuma" and skip it if the device is Pi Zero
            if [[ "$(basename "$item")" = "uptime-kuma" ]] && [ "$is_Zero" = true ]; then
                continue
            fi

            # If the destination folder is "etc", use sudo to copy the items
            if [ "$(basename "$folder")" = "etc" ]; then
                sudo cp -r "$item" "$dest"
            else
                cp -r "$item" "$dest"
            fi
        done
    fi
done
