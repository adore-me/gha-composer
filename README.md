# gha-composer

## Description
Run composer install with custom PHP image.

## Inputs 
| Key                         | Required  | Default                           | Description                                                                                    |
|-----------------------------|-----------|-----------------------------------|------------------------------------------------------------------------------------------------|
| **php-image**               | **true**  | `''`                              | PHP image to use (fully qualified image address. ex: quay.io/adoreme/nginx-fpm-alpine:v0.0.1). |
| **composer-cache-dir**      | **true**  | `/.composer/cache`                | Composer cache directory.                                                                      |
| **composer-host-cache-dir** | **true**  | `/home/runner/.composer/cache`    | Composer host cache directory.                                                                 |
| **composer-home**           | **true**  | `/.composer/`                     | Composer home directory.                                                                       |
| **composer-no-dev**         | **true**  | `false`                           | Install/or not dev dependencies.                                                               |
| **gh-oauth-token**          | **false** | `''`                              | GitHub token for pulling private GitHub dependencies.                                          |

## Outputs
None.

## Notes
ℹ This action also checks for `composer.lock` and does a `composer validate` before running `composer install`.  
Failing these checks will result in a failed action.

**FYI**: in order to speed up the build, we create a GitHub actions cache with the following key: `composer-cache-${{ hashFiles('composer.lock') }}`.  
This means that each time a build for the same `composer.lock` happens, the data will be restored and used from cache.

### Example of step configuration and usage:
```yaml
steps:
  - name: 'Run Composer Install'
    uses: adore-me/composer-action@master
    with:
      php-image-tag: SOME_IMAGE_TAG
      gh-oauth-token: ${{ secrets.GH_PRIVATE_ACTIONS_TOKEN }}
```
