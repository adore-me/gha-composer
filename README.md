# gha-composer

## Description
Run composer install with custom PHP image.

## Inputs 
Key              | Description
---------------- | -------------
**php-image-tag** | PHP image tag to use. Takes precedence over the PHP_IMAGE_TAG environment variable.
**composer-cache-dir** | Composer cache directory.
**composer-home** | Composer home directory.
**no-dev** | Install/or not dev dependencies.
**gh-oauth-token** | GitHub token for pulling private dependencies.

## Outputs
None.

### Example of step configuration and usage:
```yaml
steps:
  - name: 'Run Composer Install'
    uses: adore-me/composer-action@master
    with:
      php-image-tag: ${{ env.PHP_IMAGE_TAG }}
      gh-oauth-token: ${{ secrets.GH_PRIVATE_ACTIONS_TOKEN }}
```
