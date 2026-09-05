#!/bin/bash

set -e

IMAGE_NAME="devops-html-app"
TAG="v1"
CONTAINER_NAME="html-app"

echo "Building Docker image..."

docker build -t ${IMAGE_NAME}:${TAG} .

echo "Removing old container..."

docker rm -f ${CONTAINER_NAME} 2>/dev/null || true

echo "Starting new container..."

docker run -d \
    --name ${CONTAINER_NAME} \
    -p 8080:80 \
    ${IMAGE_NAME}:${TAG}

echo "Checking container..."

docker ps | grep ${CONTAINER_NAME}

echo "Deployment successful!"