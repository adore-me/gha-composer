#!/bin/bash

# Colors
RD='\033[0;31m'
GR='\033[0;32m'
YL='\033[0;33m'
BL='\033[0;34m'
NC='\033[0m'

COMPOSER_COMMAND="composer install"
if [[ $INPUT_COMPOSER_NO_DEV == "true" ]]; then
  COMPOSER_COMMAND=$COMPOSER_COMMAND" --no-dev"
fi

echo -e "${BL}Info:${NC} Configuring composer..."
docker exec php-container bash -c "composer config --global github-oauth.github.com $INPUT_GH_OAUTH_TOKEN \
    && composer config repo.packagist composer https://packagist.org"

composerError=false
echo -e "${BL}Info:${NC} Checking for lock file..."
if [ ! -f "composer.lock" ]; then
  errorMessage="composer.lock file not found! Please commit your composer.lock file to your repository."
  echo "::error::$errorMessage"
  echo "::set-output name=composer-error::true"
  echo "::set-output name=composer-error-message::$errorMessage"
  composerError=true
else
  echo -e "${BL}Info:${NC} Lock file found! All good..."
fi

echo -e "${BL}Info:${NC} Checking composer config..."
validateOutput=$(docker exec -t php-container bash -c "composer validate --no-check-all --no-check-publish --no-ansi")
COMPOSER_CHECK_EXIT_CODE=$?
if [ "$COMPOSER_CHECK_EXIT_CODE" != "0" ]; then
  encodedOutput=$(python3 -c "content='''$validateOutput''';print(content.replace(\"\r\", \"%0A\").replace(\"\n\", \"%0A\").replace(\"'\", \"\").replace(\"\\\"\", \"\").replace(\"\`\", \"\"))")
  errorMessage="Composer validation has errors... Check Composer Install logs for more info.%0A$encodedOutput"
  echo "::error::$errorMessage"
  echo "::set-output name=composer-error::true"
  echo "::set-output name=composer-error-message::$errorMessage"
  composerError=true
fi

if [ "$composerError" = true ]; then
  exit 1
fi

echo -e "${BL}Info:${NC} Running composer install.."
docker exec php-container bash -c "$COMPOSER_COMMAND"
