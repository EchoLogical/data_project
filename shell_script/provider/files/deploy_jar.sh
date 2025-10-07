#!/bin/bash

CONTAINER_NAME=provider-service-latest
IMAGE_NAME=provider-service:latest

DB_HOST=svrqw16ghl01
DB_NAME=Provider
DB_USER=avrist
DB_PASSWORD=12345678
STORAGE_PATH=/opt/provider

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
    -e SPRING_PROFILES_ACTIVE=uat \
    -e SPRING_DATASOURCE_HOST=$DB_HOST \
    -e SPRING_DATASOURCE_DATABASE_NAME=$DB_NAME \
    -e SPRING_DATASOURCE_USERNAME=$DB_USER \
    -e SPRING_DATASOURCE_PASSWORD=$DB_PASSWORD \
    -e STORAGE_PATH=$STORAGE_PATH \
    --name $CONTAINER_NAME \
    -p 8082:8082 \
    -v /opt/provider:/opt/provider \
    -e TZ=Asia/Jakarta \
    -t $IMAGE_NAME

docker ps --filter "name=$CONTAINER_NAME"