#!/bin/bash

# ----------- Preliminary update of all installed packages -----------
sudo apt update
sudo apt full-upgrade -y
# ----------- ----------- ----------- ----------- ----------- --------

# ----------- Install required packages -----------
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

# ----------- Launch container from docker-compose file, if present -----------
container_launch() {
  dir="$1"

  for file in "$1/*"; do
    if [ "$file" = "docker-compose.yml" ]; then
      sudo docker-compose up -d
    fi
  done
# ----------- ----------- ----------- ----------- ----------- ----------- ------
    

}

# ----------- Function to move folder in their respective place -----------
move () {
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
                  container_launch "/etc/$dest/$item"
              else
                  cp -r "$item" "$dest"
              fi
          done
      fi
  done
}
# ----------- ----------- ----------- ----------- ----------- -----
