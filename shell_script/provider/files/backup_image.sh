#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Source the environment variables
echo "locating config file $(pwd)/provider.env.sh"
if [ -f "$(pwd)/provider.env.sh" ]; then
    source "$(pwd)/provider.env.sh"
else
    echo "Error: provider.env.sh file not found"
    exit 1
fi

# If IMAGE_FILE_BACKUP_PATH is not set in provider.env.sh, prompt for it
if [ -z "$IMAGE_FILE_BACKUP_PATH" ]; then
    read -p "Enter backup path for Docker image: " IMAGE_FILE_BACKUP_PATH
fi

# Ensure the backup path exists
if [ ! -d "$IMAGE_FILE_BACKUP_PATH" ]; then
    echo "Creating backup path: $IMAGE_FILE_BACKUP_PATH"
    mkdir -p "$IMAGE_FILE_BACKUP_PATH" || { echo "Failed to create backup path"; exit 1; }
fi

# Backup the Docker image
echo "Backing up Docker image to $IMAGE_FILE_BACKUP_PATH/${IMAGE_FILE_NAME}"
docker save -o "$IMAGE_FILE_BACKUP_PATH/${IMAGE_FILE_NAME}" "$IMAGE_NAME" || { echo "Failed to backup Docker image"; exit 1; }
echo "Docker image backup completed successfully"