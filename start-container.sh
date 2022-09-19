#!/bin/bash

# Colors
RD='\033[0;31m'
GR='\033[0;32m'
YL='\033[0;33m'
BL='\033[0;34m'
NC='\033[0m'

INPUT_PHP_IMAGE="quay.io/adoreme/nginx-fpm-alpine:php-7.4.3-c2-v1.1.1"

if [ -z "$INPUT_PHP_IMAGE" ]; then
  echo "::error::No PHP image provided"
  exit 1
fi

echo -e "${BL}Info:${NC} Booting container with image: ${GR}$INPUT_PHP_IMAGE${NC}"
docker run \
  -d \
  --name php-container \
  --platform linux/amd64 \
  -v "$PWD":/var/www \
  -v "$INPUT_COMPOSER_HOST_CACHE_DIR":"$INPUT_COMPOSER_CACHE_DIR" \
  -e COMPOSER_HOME="$INPUT_COMPOSER_HOME" \
  -e COMPOSER_CACHE_DIR="$INPUT_COMPOSER_CACHE_DIR" \
  "$INPUT_PHP_IMAGE"
