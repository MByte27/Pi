#!/bin/bash

# ----------- Preliminary update of all installed packages -----------
#sudo apt update
#sudo apt full-upgrade -y
# ----------- ----------- ----------- ----------- ----------- --------

# ----------- Install required packages -----------
#sudo apt install fio docker-compose lsof python3-pip python3-venv -y
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

  origin=$(pwd)

  for file in "$1/"*; do
    if [ "$(basename "$file")" = "docker-compose.yml" ]; then
      echo "$file found! Launching container"
      cd "$1"
      sudo docker-compose up -d
      cd $origin
    fi
  done
}
# ----------- ----------- ----------- ----------- ----------- ----------- ------

# ----------- Function to move folder in their respective place -----------
move () {
# ----------- Directories' code ----------- ----------- ----------- -------
  for folder in "$src"/*; do
      if [ -d $folder ]; then
          dest="$(basename "$folder")"
	  echo "Dest: $dest"
  
          # Loop over items inside each folder
          for item in "$folder"/*; do
	      # Check if the item is "uptime-kuma" and skip it if the device is Pi Zero
              if [ "$(basename "$item")" = "uptime-kuma" ] && [ "$is_Zero" = true ]; then
		  echo "Skipping Uptime-Kuma.."
                  continue
              fi
  
              # If the destination folder is "etc", use sudo to copy the items
              if [ "$dest" = "etc" ]; then
#                  sudo cp -r "$item" "/$dest/$(basename "$item")"
#                  container_launch "/$dest/$(basename "$item")"
		  echo "Copy from: $item to /$dest/$(basename "$item")"
              else
	      	if [ $dest = "pietro" ]; then
                   dest="/home/$dest"
		fi
                cp -r "$item" "$dest/$(basename "$item")"
	        container_launch "$dest/$(basename "$item")"
 	        echo "Copy from $item to $dest/$(basename "$item")"
              fi
          done
      fi
  done
# ----------- Files' code ----------- ----------- ----------- -----
  for filepath in "$src"/*; do
    file="$(basename "$filepath")"
    if [ -f "$file" ]; then
      if [ "$file" = "README.md" ]; then
        echo "Skipping README.md.. "
	continue
      else
	echo "Copying file $file.. "
#        cp "$file" ".."
      fi
    fi
  done
}
# ----------- ----------- ----------- ----------- ----------- -----


move
