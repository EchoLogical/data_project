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

# Check if the tar file exists
if [ ! -f "${IMAGE_FILE_NAME}.tar" ]; then
    echo "Docker image tar file not found: ${IMAGE_FILE_NAME}.tar"
    exit 1
fi

# Load the Docker image from the tar file
docker load -i ${CONTAINER_NAME}.tar || { echo "Failed to load Docker image"; exit 1; }

# Prompt for container port
read -p "Enter container port: " CONTAINER_PORT

# Validate that the port is a number
if ! [[ "$CONTAINER_PORT" =~ ^[0-9]+$ ]]; then
    echo "Invalid port number: $CONTAINER_PORT"
    exit 1
fi

# Ensure the storage path exists and is writable
if [ ! -d "$STORAGE_PATH" ]; then
    echo "Creating storage path: $STORAGE_PATH"
    sudo mkdir -p "$STORAGE_PATH" || { echo "Failed to create storage path"; exit 1; }
    sudo chown $(whoami):$(whoami) "$STORAGE_PATH" || { echo "Failed to set permissions on storage path"; exit 1; }
fi

# Run container
echo "Running container"
echo "Container port: $CONTAINER_PORT"
echo "Storage path: $STORAGE_PATH"
echo "Database: $DB_NAME, Host: $DB_HOST, Username: $DB_USER, Password: ********"

docker run -d \
    --restart=always \
    -e SPRING_PROFILES_ACTIVE=uat \
    -e SPRING_DATASOURCE_HOST=$DB_HOST \
    -e SPRING_DATASOURCE_DATABASE_NAME=$DB_NAME \
    -e SPRING_DATASOURCE_USERNAME=$DB_USER \
    -e SPRING_DATASOURCE_PASSWORD=$DB_PASSWORD \
    -e STORAGE_PATH=$STORAGE_PATH \
    --name $CONTAINER_NAME \
    -p ${CONTAINER_PORT}:8082 \
    -v ${STORAGE_PATH}:${STORAGE_PATH} \
    -e TZ=Asia/Jakarta \
    -t $IMAGE_NAME || {
        echo "Failed to run Docker container, rollback..."
        cleanup
        exit 1
    }

docker ps --filter "name=$CONTAINER_NAME"