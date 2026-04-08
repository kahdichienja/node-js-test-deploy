#!/bin/bash
set -e

echo "Loading environment variables from .env..."
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | awk '/=/ {print $1}')
else
    echo "Error: .env file not found."
    exit 1
fi

echo "Logging in to Docker Hub..."
echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo "Building Docker image..."
docker build -t "$IMAGE_NAME:latest" .

echo "Pushing image to Docker Hub registry..."
docker push "$IMAGE_NAME:latest"

echo "Image successfully pushed to $IMAGE_NAME:latest"
