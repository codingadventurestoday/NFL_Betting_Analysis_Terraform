#!/bin/bash

echo "Starting VM setup script..."
sudo apt-get update

# Define the disk and mount point
DISK_DEV="/dev/disk/by-id/google-mysql-data-disk"
MOUNT_POINT="/mnt/mysql-data"

# Check if the disk is already formatted, if not, format it with an ext4 filesystem
if ! sudo blkid "$DISK_DEV"; then
  echo "Formatting disk..."
  sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard "$DISK_DEV"
fi

# Create the mount point directory if it doesn't exist
sudo mkdir -p "$MOUNT_POINT"

# Mount the disk and add it to /etc/fstab to mount automatically on reboot
if ! grep -q "$MOUNT_POINT" /etc/fstab; then
  echo "Mounting disk and updating /etc/fstab..."
  sudo mount -o discard,defaults "$DISK_DEV" "$MOUNT_POINT"
  echo UUID=$(sudo blkid -s UUID -o value "$DISK_DEV") "$MOUNT_POINT" ext4 discard,defaults 0 2 | sudo tee -a /etc/fstab
fi

echo "Starting installment of Docker"

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

# Pull Docker images (adjust these commands for your project)
sudo docker pull mysql:9.4
sudo docker pull python:3.11-slim
sudo docker pull rabbitmq:4.1.3

sudo docker run -d --name mysql-db \
  -v "$MOUNT_POINT"/mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=your_secure_password \
  mysql:8.0

echo "Successfully running MySQL image"

sudo docker run -d --name python-app \
  -v "$MOUNT_POINT"/app-code:/app \
  python:3.11-slim python3 /app/your_script.py

echo "Successfully running python image"

sudo docker run -d --name rabbitmq-server \
  -p 5672:5672 -p 15672:15672 \
  -v "$MOUNT_POINT"/rabbitmq-data:/var/lib/rabbitmq \
  rabbitmq:4.1.3

echo "Successfully running RabbitMQ image"

echo "VM setup script finished successfully."