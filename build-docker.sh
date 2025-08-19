#!/bin/bash

# Outline Docker Build Script with Context Path Support
# Usage: ./build-docker.sh [tag]

# Set default tag
TAG=${1:-"outline-context-path:latest"}
BASE_TAG="outline-base:$(date +%s)"

echo "🔨 Building Outline Docker image with context path support..."
echo "📦 Base image tag: $BASE_TAG"
echo "🏷️  Final image tag: $TAG"

# Build base image
echo ""
echo "📋 Step 1: Building base image..."
docker build -f Dockerfile.base -t "$BASE_TAG" . || {
    echo "❌ Failed to build base image"
    exit 1
}

# Build final image
echo ""
echo "📋 Step 2: Building final image..."
docker build --build-arg BASE_IMAGE="$BASE_TAG" -t "$TAG" . || {
    echo "❌ Failed to build final image"
    exit 1
}

# Clean up base image
echo ""
echo "🧹 Cleaning up intermediate base image..."
docker rmi "$BASE_TAG" 2>/dev/null || true

echo ""
echo "✅ Successfully built: $TAG"
echo ""
echo "🚀 To run the image:"
echo "   docker run -p 3000:3000 \\"
echo "     -e CONTEXT_PATH='/wiki' \\"
echo "     -e URL='http://localhost:3000/wiki' \\"
echo "     -e DATABASE_URL='your-db-url' \\"
echo "     -e REDIS_URL='your-redis-url' \\"
echo "     -e SECRET_KEY='your-secret' \\"
echo "     -e UTILS_SECRET='your-utils-secret' \\"
echo "     $TAG"
echo ""
echo "📖 See docs/CONTEXT_PATH.md for full configuration guide"