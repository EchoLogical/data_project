#!/bin/bash
set -e  # stop script kalau ada error

IMAGE_NAME="registry.codeoffice.xyz/all-avrist-assurance-ecommerce-webhook"
IMAGE_TAG="latest"
DOCKERFILE="Dockerfile.development"
OUTPUT_TAR="ecommerce_webhook.tar"

echo "========================================"
echo "🚀 Starting Docker build for $IMAGE_NAME:$IMAGE_TAG"
echo "========================================"

# Step 1: Remove existing image (if exists)
if sudo docker images | grep -q "$(basename $IMAGE_NAME)"; then
  echo "🧹 Removing old image..."
  sudo docker rmi -f "$IMAGE_NAME:$IMAGE_TAG" || true
else
  echo "ℹ️ No old image found, skipping remove."
fi

# Step 2: Build new image
echo "🏗️  Building Docker image from $DOCKERFILE ..."
sudo docker build -f "$DOCKERFILE" -t "$IMAGE_NAME:$IMAGE_TAG" .

# Step 3: Save image to tar
echo "📦 Saving image to $OUTPUT_TAR ..."
mkdir -p "$(dirname "$OUTPUT_TAR")"
sudo docker save "$IMAGE_NAME:$IMAGE_TAG" > "$OUTPUT_TAR"

# Step 4: Remove local image (optional cleanup)
echo "🗑️  Removing built image from local cache ..."
sudo docker rmi "$IMAGE_NAME:$IMAGE_TAG" || true

echo "✅ Build and export completed successfully!"
echo "📁 TAR file saved at: $OUTPUT_TAR"
echo "========================================"
