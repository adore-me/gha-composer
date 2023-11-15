#!/bin/bash

# Colors
BL='\033[0;34m'
NC='\033[0m'

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
