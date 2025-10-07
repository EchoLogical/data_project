#!/bin/bash

# Load variables from the config.env.sh file
source ./config.env.sh

# Check if Docker is running
if ! command -v docker &> /dev/null; then
  echo "Docker is not installed or not running. Please start Docker and try again."
  exit 1
fi

# Check if the Docker image exists
if docker image inspect "$JDK_IMAGE_NAME" > /dev/null 2>&1; then
  echo "Docker image '$JDK_IMAGE_NAME' already exists."
else
  echo "Docker image '$JDK_IMAGE_NAME' not found. Loading from file: $JDK_IMAGE_FILE_PATH"

  # Check if the image file exists
  if [ -f "$JDK_IMAGE_FILE_PATH" ]; then
    docker load -i "$JDK_IMAGE_FILE_PATH"
    if [ $? -eq 0 ]; then
      echo "Docker image loaded successfully."
    else
      echo "Failed to load Docker image."
      exit 1
    fi
  else
    echo "Error: Image file '$JDK_IMAGE_FILE_PATH' not found."
    exit 1
  fi
fi

# Check if the Docker container exists and stop/remove it if it does
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}$"; then
  echo "Stopping the Docker container: $CONTAINER_NAME"
  docker stop "$CONTAINER_NAME"

  echo "Removing the Docker container: $CONTAINER_NAME"
  docker rm "$CONTAINER_NAME"
else
  echo "Docker container '$CONTAINER_NAME' does not exist. Skipping stop and removal."
fi

# Check if the Docker image exists and remove it if it does
if docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
  echo "Removing the Docker image: $IMAGE_NAME"
  docker rmi "$IMAGE_NAME"
else
  echo "Docker image '$IMAGE_NAME' does not exist. Skipping removal."
fi

echo "Building a new Docker image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" .

# Check if the build was successful
if [ $? -eq 0 ]; then
  echo "Docker image '$IMAGE_NAME' built successfully."
  echo "Removing $JDK_IMAGE_NAME"
  docker rmi $JDK_IMAGE_NAME
else
  echo "Failed to build Docker image '$IMAGE_NAME'."
  docker rmi $JDK_IMAGE_NAME
  exit 1
fi

# Run docker image in server
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
  "$IMAGE_NAME"

# Check if the container started successfully
if [ $? -eq 0 ]; then
  echo "Docker container '$CONTAINER_NAME' is running."
else
  echo "Failed to start Docker container '$CONTAINER_NAME'."
  exit 1
fi

# View status of the container
docker ps -a | grep "$CONTAINER_NAME"
