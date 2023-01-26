#!/bin/bash

# Colors
RD='\033[0;31m'
GR='\033[0;32m'
YL='\033[0;33m'
BL='\033[0;34m'
NC='\033[0m'

if [[ $INPUT_COMPOSER_SELF_UPDATE == "true" ]]; then
  echo -e "${BL}Info:${NC} Updating composer..."
  version=""
  if [[ $INPUT_COMPOSER_SELF_UPDATE_VERSION != "" ]]; then
    version="$INPUT_COMPOSER_SELF_UPDATE_VERSION"
  fi

  echo -e "${BL}Info:${NC} running: composer self-update ${version}"
  docker exec php-container bash -c "composer self-update ${version}"
fi

COMPOSER_COMMAND="composer install --prefer-dist"
if [[ $INPUT_COMPOSER_NO_DEV == "true" ]]; then
  COMPOSER_COMMAND=$COMPOSER_COMMAND" --no-dev"
fi

echo -e "${BL}Info:${NC} Configuring composer..."
docker exec php-container bash -c "composer config --global github-oauth.github.com $INPUT_GH_OAUTH_TOKEN"

echo -e "${BL}Info:${NC} Checking for lock file..."
if [ ! -f "composer.lock" ]; then
  errorMessage="composer.lock file not found! Please commit your composer.lock file to your repository."
  echo "::error::$errorMessage"
  echo "composer-error-message=$errorMessage" >> "$GITHUB_OUTPUT"
  echo "composer-error=true" >> "$GITHUB_OUTPUT"
  exit 1
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
  echo "composer-error-message=$errorMessage" >> "$GITHUB_OUTPUT"
  echo "composer-error=true" >> "$GITHUB_OUTPUT"
  exit 1
else
  echo -e "${BL}Info:${NC} composer validate passed..."
fi

echo "composer-error=false" >> "$GITHUB_OUTPUT"

echo -e "${BL}Info:${NC} Running composer install.."
echo -e "${BL}Info:${NC} running: $COMPOSER_COMMAND"
docker exec php-container bash -c "$COMPOSER_COMMAND"
