#!/bin/bash

# Colors
RD='\033[0;31m'
GR='\033[0;32m'
YL='\033[0;33m'
BL='\033[0;34m'
NC='\033[0m'

IMAGE="quay.io/adoreme/nginx-fpm-alpine:$INPUT_PHP_IMAGE_TAG"

COMPOSER_COMMAND="composer install"
if [[ $INPUT_NO_DEV == "true" ]]; then
  COMPOSER_COMMAND=$COMPOSER_COMMAND" --no-dev"
fi

echo -e "${BL}INFO:${NC} Running composer with image: ${GR}nginx-fpm-alpine:$IMAGE${NC}"
docker run \
  --platform linux/amd64 \
  -v "$PWD":/var/www \
  -e COMPOSER_HOME="$INPUT_COMPOSER_HOME" \
  -e COMPOSER_CACHE_DIR="$INPUT_COMPOSER_CACHE_DIR" \
  "$IMAGE" \
  /bin/bash -c "echo -e '${BL}INFO:${NC} Configure composer' \
    && composer config --global github-oauth.github.com $INPUT_GH_OAUTH_TOKEN \
    && composer config repo.packagist composer https://packagist.org \
    && echo -e '${BL}INFO:${NC} Install composer dependencies' \
    && ${COMPOSER_COMMAND}"
