#!/bin/bash

# Colors
RD='\033[0;31m'
GR='\033[0;32m'
YL='\033[0;33m'
BL='\033[0;34m'
NC='\033[0m'

if [ -z "$INPUT_PHP_IMAGE" ]; then
  echo "::error::No PHP image provided"
  exit 1
fi

COMPOSER_COMMAND="composer install"
if [[ $INPUT_COMPOSER_NO_DEV == "true" ]]; then
  COMPOSER_COMMAND=$COMPOSER_COMMAND" --no-dev"
fi

echo -e "${BL}Info:${NC} Running composer with image: ${GR}$INPUT_PHP_IMAGE${NC}"
docker run \
  --platform linux/amd64 \
  -v "$PWD":/var/www \
  -v "$INPUT_COMPOSER_HOST_CACHE_DIR":"$INPUT_COMPOSER_CACHE_DIR" \
  -e COMPOSER_HOME="$INPUT_COMPOSER_HOME" \
  -e COMPOSER_CACHE_DIR="$INPUT_COMPOSER_CACHE_DIR" \
  "$INPUT_PHP_IMAGE" \
  "/bin/bash" "-c" "echo -e '${BL}Info:${NC} Configure composer' \
    && composer config --global github-oauth.github.com $INPUT_GH_OAUTH_TOKEN \
    && composer config repo.packagist composer https://packagist.org \
    && echo -e '${BL}Info:${NC} Install composer dependencies' \
    && $COMPOSER_COMMAND"
