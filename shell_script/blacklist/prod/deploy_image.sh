#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Source the environment variables
echo "locating config file $(pwd)/config.env.sh"
if [ -f "$(pwd)/config.env.sh" ]; then
    source "$(pwd)/config.env.sh"
else
    echo "Error: config.env.sh file not found"
    exit 1
fi

# Function to clean up container and image on failure
cleanup() {
    echo "Cleaning up..."
    if docker inspect $CONTAINER_NAME &> /dev/null; then
        docker container rm -f $CONTAINER_NAME || echo "Failed to remove container"
    fi
    if docker image inspect $IMAGE_NAME &> /dev/null; then
        docker image rm $IMAGE_NAME || echo "Failed to remove image"
    fi
}

# Trap errors to execute cleanup
trap 'cleanup' ERR

# Check if the tar file exists
if [ ! -f "${IMAGE_FILE_PATH}/${IMAGE_FILE_NAME}" ]; then
    echo "Docker image tar file not found: ${IMAGE_FILE_PATH}/${IMAGE_FILE_NAME}"
    exit 1
fi

# Check if the container is running before stopping it
if docker inspect -f '{{.State.Running}}' $CONTAINER_NAME &> /dev/null; then
    docker container stop $CONTAINER_NAME || { echo "Failed to stop container"; exit 1; }
fi

# Check if the container exists before removing it
if docker inspect $CONTAINER_NAME &> /dev/null; then
    docker container rm $CONTAINER_NAME || { echo "Failed to remove container"; exit 1; }
fi

# Check if the Docker image exists before removing it
if docker image inspect $IMAGE_NAME &> /dev/null; then
    docker image rm $IMAGE_NAME
fi


# Load the Docker image from the tar file
docker load -i ${IMAGE_FILE_PATH}/${IMAGE_FILE_NAME} || { echo "Failed to load Docker image"; exit 1; }

# Run container
echo "Running container"
echo "Container port: $CONTAINER_PORT"
echo "Storage path: $STORAGE_PATH"
echo "Database: $DB_NAME, Host: $DB_HOST, Username: $DB_USER, Password: ********"

docker run -d -p $CONTAINER_PORT:80 --restart=always --name "$CONTAINER_NAME" \
  -e DB_CNC_HOST="$DB_CNC_HOST" \
  -e DB_CNC_PORT="$DB_CNC_PORT" \
  -e DB_CNC_NAME="$DB_CNC_NAME" \
  -e DB_CNC_USERNAME="$DB_CNC_USERNAME" \
  -e DB_CNC_PASSWORD="$DB_CNC_PASSWORD" \
  -e DB_AMSSEC_HOST="$DB_AMSSEC_HOST" \
  -e DB_AMSSEC_PORT="$DB_AMSSEC_PORT" \
  -e DB_AMSSEC_NAME="$DB_AMSSEC_NAME" \
  -e DB_AMSSEC_USERNAME="$DB_AMSSEC_USERNAME" \
  -e DB_AMSSEC_PASSWORD="$DB_AMSSEC_PASSWORD" \
  -e CACHE_REDIS_HOST="$CACHE_REDIS_HOST" \
  -e CACHE_REDIS_PORT="$CACHE_REDIS_PORT" \
  -e AMSSEC_SECRET_KEY="$AMSSEC_SECRET_KEY" \
  -e AMSSEC_ENDPOINT="$AMSSEC_ENDPOINT" \
  -e AMSSEC_USERNAME="$AMSSEC_USERNAME" \
  -e AMSSEC_PASSWORD="$AMSSEC_PASSWORD" \
  -e AMSSEC_PARTNER_CODE="$AMSSEC_PARTNER_CODE" \
  -e AMSSEC_DEVICE_TYPE="$AMSSEC_DEVICE_TYPE" \
  -e NSSSEC_SECRET_KEY="$NSSSEC_SECRET_KEY" \
  -e LDAP_BASE="$LDAP_BASE" \
  -e LDAP_URL="$LDAP_URL" \
  -e LDAP_USERNAME="$LDAP_USERNAME" \
  -e LDAP_PASSWORD="$LDAP_PASSWORD" \
  "$IMAGE_NAME" || {
        echo "Failed to run Docker container, rollback..."
        cleanup
        exit 1
    }

docker ps --filter "name=$CONTAINER_NAME"