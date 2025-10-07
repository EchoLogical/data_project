#!/bin/bash

CONTAINER_NAME=fjenkins
IMAGE_NAME=fjenkins:latest

# Check if the container is running before stopping it
if docker inspect -f '{{.State.Running}}' $CONTAINER_NAME &> /dev/null; then
    docker container stop $CONTAINER_NAME
fi

# Check if the container exists before removing it
if docker inspect $CONTAINER_NAME &> /dev/null; then
    docker container rm $CONTAINER_NAME
fi

# Check if the Docker image exists before removing it
if docker inspect $IMAGE_NAME &> /dev/null; then
    docker image rm $IMAGE_NAME
fi

# Build docker image
docker build --no-cache -t $IMAGE_NAME .

# Run docker container
docker run -d \
    --restart=always \
    --name $CONTAINER_NAME \
    -p 8082:8082 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /etc/ssh:/etc/ssh \
    -e TZ=Asia/Jakarta \
    -t $IMAGE_NAME

docker ps --filter "name=$CONTAINER_NAME"