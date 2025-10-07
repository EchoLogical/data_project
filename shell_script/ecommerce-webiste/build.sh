#!/bin/bash

set -e  # Exit if error exists

IMAGE_NAME="website"
IMAGE_TAG="latest"
TAR_FILE="website.tar"
DOCKERFILE="Dockerfile.uat"

echo "=== Starting Docker Build Process ==="

# Remove existing tar file if exists
if [ -f "$TAR_FILE" ]; then
    echo "Remove existing tar file..."
    sudo rm -f "$TAR_FILE"
fi

# Remove existing Docker image if exists
if sudo docker images | grep -q "^$IMAGE_NAME "; then
    echo "Remove existing Docker image..."
    sudo docker rmi -f "$IMAGE_NAME:$IMAGE_TAG" || true
fi

# Build Docker image
echo "Building Docker image..."
sudo docker build -f "$DOCKERFILE" -t "$IMAGE_NAME:$IMAGE_TAG" .

# Verify build success
if [ $? -eq 0 ]; then
    echo "✓ Docker image successfully built"
else
    echo "✗ Failed to build Docker image"
    exit 1
fi

# Save image to tar file
echo "Save docker image to tar file... $TAR_FILE"
sudo docker save "$IMAGE_NAME:$IMAGE_TAG" -o "$TAR_FILE"

echo "Remove existing Docker image..."
sudo docker rmi -f "$IMAGE_NAME:$IMAGE_TAG"

# Verify tar file creation
if [ -f "$TAR_FILE" ]; then
    TAR_SIZE=$(du -h "$TAR_FILE" | cut -f1)
    echo "✓ Image successfully saved to $TAR_FILE (Size: $TAR_SIZE)"
else
    echo "✗ Failed to build Docker image"
    exit 1
fi

echo "=== Build Process Completed Successfully ==="