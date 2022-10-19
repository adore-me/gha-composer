# gha-composer

## Description
Run composer install with custom PHP image.  
ℹ The PHP image used can be passed through `php-image` input or through `PROJECT_IMAGE` env variable.  
**NOTE:** If you use [gha-image-setup](https://github.com/adore-me/gha-image-setup) in a previous step you don't need to worry about it, as it already sets the `PROJECT_IMAGE` 👌

## Inputs 
| Key                         | Required  | Default                           | Description                                                                                    |
|-----------------------------|-----------|-----------------------------------|------------------------------------------------------------------------------------------------|
| **php-image**               | **false** | `''`                              | PHP image to use (fully qualified image address. ex: quay.io/adoreme/nginx-fpm-alpine:v0.0.1). |
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
  # Needed if PHP/Composer image is in a private registry
  - name: Login quay
    uses: docker/login-action@v1
    with:
      registry: quay.io
      password: ${{ secrets.GHA_QUAY_ROBOT_PASSWORD }}
      username: ${{ secrets.GHA_QUAY_ROBOT_USERNAME }}

  - name: 'Run Composer Install'
    uses: adore-me/composer-action@master
    with:
      php-image: SOME_IMAGE # pr `PROJECT_IMAGE` env var set
      gh-oauth-token: ${{ secrets.GH_PRIVATE_ACTIONS_TOKEN }}
```
