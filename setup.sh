#!/bin/bash

# TESTED ON Raspberry Pi 0, Linux 6.6.31+rpt-rpi-v6

src="/home/pietro/Raspberry/essentials"

copy_in_system() {
  # $1 = etc or home/pietro
  # $2 = ntfy, uptime-kuma, agnostics or anything else
  sudo cp -r "$src/$1/$2" "/$1"
  echo "/$1/$2"
}

activate() {
  cd "$1"
  # Make sure you're in the right directory before executing this
  if [ -f "docker-compose.yml" ]; then
    sudo docker-compose up -d
  fi
}

for dir in "$src/etc/"*; do
  # get dir name only
  base_dir=$(basename "$dir")
  res=$(copy_in_system "etc" "$base_dir")
  activate "$res"
done


-----------------------------------------------------------------------------------------------------
# v2

#!/bin/bash

# preliminary update of all packages installed ####
sudo apt update
sudo apt full-upgrade -y
# #################################################

# install pkgs required ###########################
sudo apt install fio docker-compose lsof -y
# #################################################

systemplace(){}

activateapp(){}


