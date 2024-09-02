# v2
#!/bin/bash

# preliminary update of all packages installed ####
sudo apt update
sudo apt full-upgrade -y
# #################################################

# install pkgs required ###########################
sudo apt install fio docker-compose lsof -y
# #################################################

move(){
  src="/home/pietro/Pi"
  sudo cp -r "$src/$1/$2" "/$1"
}

activateapp(){
  cd "$1"
    # Make sure you're in the right directory before executing this
    if [ -f "docker-compose.yml" ]; then
      sudo docker-compose up -d
    fi
}

for dir in "$src/etc/*"; do
  # get dir name only
  base_dir=$(basename "$dir")
  res=$(copy_in_system "etc" "$base_dir")
  activate "$res"
done

