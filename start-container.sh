#!/bin/bash

# Colors
RD='\033[0;31m'
GR='\033[0;32m'
YL='\033[0;33m'
BL='\033[0;34m'
NC='\033[0m'

ACTION_IMAGE=""
if [ -n "$PROJECT_IMAGE" ]; then
  echo -e "${BL}Info:${NC} Project image found in env var PROJECT_IMAGE: ${GR}$PROJECT_IMAGE${NC}"
  ACTION_IMAGE="$PROJECT_IMAGE"
fi

if [ -n "$INPUT_PHP_IMAGE" ]; then
  echo -e "${BL}Info:${NC} Project image found in input. Using ${GR}$PROJECT_IMAGE${NC}"
  ACTION_IMAGE="$INPUT_PHP_IMAGE"
fi

if [ -z "$ACTION_IMAGE" ]; then
  echo "::error::No image provided"
  exit 1
fi

echo -e "${BL}Info:${NC} Booting container with image: ${GR}$ACTION_IMAGE${NC}"
docker run \
  -d \
  --name php-container \
  --platform linux/amd64 \
  -v "$PWD":/var/www \
  -v "$INPUT_COMPOSER_HOST_CACHE_DIR":"$INPUT_COMPOSER_CACHE_DIR" \
  -e COMPOSER_HOME="$INPUT_COMPOSER_HOME" \
  -e COMPOSER_CACHE_DIR="$INPUT_COMPOSER_CACHE_DIR" \
  "$ACTION_IMAGE"
