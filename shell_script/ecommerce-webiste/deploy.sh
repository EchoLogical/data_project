#!/bin/bash

set -e  # Exit immediately if any command returns non-zero status

# Configuration variables
IMAGE_NAME="website"
SERVICE_NAME="ecommerce_website"
BACKUP_DIR="/home/avrist/repo/website/backup"
IMAGE_DIR="/home/avrist/repo/website/image"
STACK_NAME="ecommerce"
COMPOSE_FILE="/home/avrist/repo/website/development.yml"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Function to request confirmation
confirm_action() {
    read -p "$1 (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
        log "Action cancelled."
        exit 0
    fi
}

# Function to check if directory exists, create if not
ensure_directory() {
    if [ ! -d "$1" ]; then
        log "Creating directory: $1"
        sudo mkdir -p "$1"
    fi
}

# Ensure backup directory exists
ensure_directory "$BACKUP_DIR"

# Backup old image
log "Backing up old image..."
BACKUP_FILE="$BACKUP_DIR/ecommerce-website_autobak_$(date '+%Y%m%d_%H%M%S').tar"
if sudo docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
    sudo docker save "$IMAGE_NAME" -o "$BACKUP_FILE"
    log "✓ Backup saved to: $BACKUP_FILE"
else
    log "⚠ Image not found, skipping backup."
fi

# Remove existing service
log "Removing existing service..."
if sudo docker service ls | grep -q "$SERVICE_NAME"; then
    sudo docker service rm "$SERVICE_NAME"
    log "✓ Service removed successfully."
else
    log "⚠ Service not found or already removed."
fi

# Remove old image
log "Removing old image..."
if sudo docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
    sudo docker rmi "$IMAGE_NAME"
    log "✓ Image removed successfully."
else
    log "⚠ Image not found or already removed."
fi

# Load new image
confirm_action "Do you want to load the new image?"
log "Loading new image..."
IMAGE_TAR="$IMAGE_DIR/$IMAGE_NAME.tar"
if [ -f "$IMAGE_TAR" ]; then
    sudo docker load -i "$IMAGE_TAR"
    log "✓ New image loaded successfully."
else
    log "✗ Error: Image file not found at $IMAGE_TAR"
    exit 1
fi

# Deploy stack
log "Deploying new stack..."
if [ -f "$COMPOSE_FILE" ]; then
    sudo docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"
    log "✓ Stack deployed successfully."
else
    log "✗ Error: Compose file not found at $COMPOSE_FILE"
    exit 1
fi

# Wait for service to be ready
log "Waiting for service to be ready..."
sleep 5

# Verify deployment
log "Verifying deployment..."
if sudo docker service ls | grep -q "$SERVICE_NAME"; then
    REPLICAS=$(sudo docker service ls --filter name="$SERVICE_NAME" --format "{{.Replicas}}")
    log "✓ Service status: $REPLICAS"
else
    log "⚠ Warning: Service not found in service list"
fi

log "=== Deployment completed successfully ==="