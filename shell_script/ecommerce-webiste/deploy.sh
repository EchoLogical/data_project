#!/bin/bash
set -e  # stop kalau ada error

SERVICE_NAME="ecommerce_website"
IMAGE_NAME="website"
STACK_NAME="ecommerce"
IMAGE_PATH="/home/avrist/repo/website/image/website.tar"
COMPOSE_FILE="/home/avrist/repo/website/development.yml"

echo "========================================"
echo "🚀 Starting redeploy for $SERVICE_NAME"
echo "========================================"

# Step 1: Remove existing service
if sudo docker service ls | grep -q "$SERVICE_NAME"; then
  echo "🧹 Removing old service: $SERVICE_NAME ..."
  sudo docker service rm "$SERVICE_NAME"
else
  echo "ℹ️ Service $SERVICE_NAME not found, skipping removal."
fi

# Step 2: Remove old image (if exists)
if sudo docker images | grep -q "$IMAGE_NAME"; then
  echo "🗑️  Removing old image: $IMAGE_NAME ..."
  sudo docker rmi -f "$IMAGE_NAME" || true
else
  echo "ℹ️ No existing image named $IMAGE_NAME found."
fi

# Step 3: Load new image from tar
if [ -f "$IMAGE_PATH" ]; then
  echo "📦 Loading image from: $IMAGE_PATH ..."
  sudo docker load < "$IMAGE_PATH"
else
  echo "❌ ERROR: Image file not found at $IMAGE_PATH"
  exit 1
fi

# Step 4: Deploy stack
if [ -f "$COMPOSE_FILE" ]; then
  echo "🚢 Deploying stack: $STACK_NAME using $COMPOSE_FILE ..."
  sudo docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"
else
  echo "❌ ERROR: Compose file not found at $COMPOSE_FILE"
  exit 1
fi

# Step 5: Verify deployment
echo "🔍 Checking service status..."
sudo docker service ps "$SERVICE_NAME" || true

# Step 6: Verify running container
echo "🐳 Checking running container..."
sudo docker ps | grep "$IMAGE_NAME" || echo "⚠️ No running container found for $IMAGE_NAME"

echo "✅ Redeploy completed successfully!"
echo "========================================"
