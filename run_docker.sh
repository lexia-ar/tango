#!/bin/bash

# Name of your Docker image
IMAGE_NAME="tango-70b:v0.0.1"

# Build the Docker image
echo "Building Docker image..."
docker build -t $IMAGE_NAME .

# Run the Docker container
echo "Running Docker container..."
docker run -p 8888:8888 --gpus all -v $(pwd):/app -it $IMAGE_NAME
