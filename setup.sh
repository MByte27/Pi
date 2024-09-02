#!/bin/bash

# preliminary update of all packages installed ####
sudo apt update
sudo apt full-upgrade -y
# #################################################

# install pkgs required ###########################
sudo apt install fio docker-compose lsof python3-pip python3-venv -y
# #################################################

src="/home/pietro/Pi"

move(){
  sudo cp -r "$src/$1/$2" "/$1"
  echo "/$1/$2"
}

docker_app_launch(){
  local dir_path="$1"
  if [ -d "$dir_path" ]; then
    cd "$dir_path" || exit
    # Make sure you're in the right directory before executing this
    if [ -f "docker-compose.yml" ]; then
      sudo docker-compose up -d
    fi
  else
    echo "Directory $dir_path does not exist."
  fi
}

for dir in "$src"/*; do
  # get dir name only
  base_dir=$(basename "$dir")
  res=$(move "etc" "$base_dir")
  docker_app_launch "$res"
done
