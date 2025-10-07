#!/bin/bash

# Load environment variables from config.sh
CONFIG_PATH=./config.sh

# Source the configuration file
source $CONFIG_PATH

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

# Build the Docker image using the custom Dockerfile
cd $SOURCE_PATH/target
docker build --no-cache -t $IMAGE_NAME -f $DOCKERFILE_PATH .

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