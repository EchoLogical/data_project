#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

IMAGE_NAME="website"
IMAGE_TAG="latest"
TAR_FILE="${IMAGE_NAME}.tar"
DOCKERFILE="Dockerfile.uat"

echo "=== 🚀 Starting Docker Build Process ==="

# Remove old tar file
if [[ -f "$TAR_FILE" ]]; then
    echo "🧹 Removing existing tar file..."
    sudo rm -f "$TAR_FILE"
fi

# Remove existing image safely
if sudo docker images --format '{{.Repository}}:{{.Tag}}' | grep -qx "${IMAGE_NAME}:${IMAGE_TAG}"; then
    echo "🧹 Removing existing Docker image..."
    sudo docker rmi -f "${IMAGE_NAME}:${IMAGE_TAG}" || true
fi

# Build the Docker image
echo "🔨 Building Docker image..."
sudo docker build \
    -f "$DOCKERFILE" \
    -t "${IMAGE_NAME}:${IMAGE_TAG}" \
    .

echo "✅ Docker image successfully built: ${IMAGE_NAME}:${IMAGE_TAG}"

# Save the image
echo "💾 Saving Docker image to tar file: ${TAR_FILE}"
sudo docker save "${IMAGE_NAME}:${IMAGE_TAG}" -o "$TAR_FILE"

# Clean up
echo "🧹 Removing built Docker image to save space..."
sudo docker rmi -f "${IMAGE_NAME}:${IMAGE_TAG}"

# Verify tar file
if [[ -f "$TAR_FILE" ]]; then
    TAR_SIZE=$(du -h "$TAR_FILE" | cut -f1)
    echo "✅ Image saved to ${TAR_FILE} (Size: ${TAR_SIZE})"
else
    echo "❌ Failed to create ${TAR_FILE}"
    exit 1
fi

sudo chmod 777 "$TAR_FILE"
echo "🎉 === Build Process Completed Successfully ==="
