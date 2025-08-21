#!/bin/bash

# Install Docker
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure Docker to use the persistent disk for data storage
sudo service docker stop
sudo mkdir -p "$MOUNT_POINT"/docker
sudo rsync -aqxP /var/lib/docker/ "$MOUNT_POINT"/docker/
sudo rm -rf /var/lib/docker
sudo ln -s "$MOUNT_POINT"/docker /var/lib/docker
sudo service docker start

echo "Docker install complete. Starting to pull and run images"
