#!/bin/bash

# ensure the docker image for mysql has volume for persistent disk at the vm level
# since the mysql db is running through a docker image when the vm gets shut down

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
source ./install_docker.sh

source ./run_containers.sh
echo "VM setup script finished successfully."