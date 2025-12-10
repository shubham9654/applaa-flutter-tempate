#!/bin/bash

# Docker Build and Push Script for Applaa Template
# Usage: ./build-and-push-docker.sh [tag]
# Example: ./build-and-push-docker.sh latest
# Example: ./build-and-push-docker.sh v1.0.0

set -e

# Configuration
DOCKER_USERNAME="shubham9654"
IMAGE_NAME="applaa-template"
TAG=${1:-latest}
FULL_IMAGE_NAME="${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "=========================================="
echo "Building Docker Image"
echo "=========================================="
echo "Image: ${FULL_IMAGE_NAME}"
echo ""

# Build the Docker image (from project root)
echo "Step 1: Building Docker image..."
cd ..
docker build -t ${FULL_IMAGE_NAME} -f Dockerfile --target web-server .
cd scripts

echo ""
echo "✅ Build completed successfully!"
echo ""

# Tag as latest if not already
if [ "$TAG" != "latest" ]; then
    echo "Step 2: Tagging as latest..."
    docker tag ${FULL_IMAGE_NAME} ${DOCKER_USERNAME}/${IMAGE_NAME}:latest
    echo "✅ Tagged as latest"
    echo ""
fi

# Check if logged in to Docker Hub
echo "Step 3: Checking Docker Hub login..."
if ! docker info | grep -q "Username"; then
    echo "⚠️  Not logged in to Docker Hub"
    echo "Please login first:"
    echo "  docker login"
    echo ""
    read -p "Press Enter after logging in, or Ctrl+C to cancel..."
fi

# Push the image
echo "Step 4: Pushing to Docker Hub..."
docker push ${FULL_IMAGE_NAME}

if [ "$TAG" != "latest" ]; then
    docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:latest
fi

echo ""
echo "=========================================="
echo "✅ Successfully pushed to Docker Hub!"
echo "=========================================="
echo ""
echo "Image: ${FULL_IMAGE_NAME}"
echo ""
echo "Pull command:"
echo "  docker pull ${FULL_IMAGE_NAME}"
echo ""
echo "Run command:"
echo "  docker run -d -p 8080:80 ${FULL_IMAGE_NAME}"
echo ""

