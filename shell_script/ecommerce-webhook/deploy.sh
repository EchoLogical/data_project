#!/bin/bash
set -e  # stop script kalau ada error

SERVICE_NAME="ecommerce_webhook"
IMAGE_NAME="registry.codeoffice.xyz/all-avrist-assurance-ecommerce-webhook"
TAR_PATH="/home/avrist/repo/webhook/image/ecommerce_webhook.tar"
STACK_FILE="/home/avrist/repo/webhook/development.yml"
STACK_NAME="ecommerce"

echo "========================================"
echo "🚀 Starting redeploy for $SERVICE_NAME"
echo "========================================"

# Step 1: Remove existing service
if sudo docker service ls | grep -q "$SERVICE_NAME"; then
  echo "🧹 Removing existing service: $SERVICE_NAME ..."
  sudo docker service rm "$SERVICE_NAME"
else
  echo "ℹ️ Service $SERVICE_NAME not found, skipping removal."
fi

# Step 2: Remove old image
if sudo docker images | grep -q "$(basename $IMAGE_NAME)"; then
  echo "🗑️ Removing old image: $IMAGE_NAME ..."
  sudo docker image rm "$IMAGE_NAME" || true
else
  echo "ℹ️ Image $IMAGE_NAME not found, skipping removal."
fi

# Step 3: Load new image
if [ -f "$TAR_PATH" ]; then
  echo "📦 Loading new image from $TAR_PATH ..."
  sudo docker load < "$TAR_PATH"
else
  echo "❌ TAR file not found: $TAR_PATH"
  exit 1
fi

# Step 4: Deploy stack
echo "🚢 Deploying stack: $STACK_NAME ..."
sudo docker stack deploy -c "$STACK_FILE" "$STACK_NAME"

# Step 5: Wait a bit for service startup
echo "⏳ Waiting for service to initialize..."
sleep 5

# Step 6: Check service status
echo "🔍 Checking service status..."
sudo docker service ps "$SERVICE_NAME" --no-trunc

# Step 7: Verify container is running
echo "🧾 Listing running containers matching image..."
sudo docker ps | grep "$(basename $IMAGE_NAME)" || echo "⚠️ No running container found for $IMAGE_NAME"

echo "✅ Redeploy complete!"
echo "========================================"
