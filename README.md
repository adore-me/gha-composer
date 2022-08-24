# gha-composer

## Description
Run composer install with custom PHP image.

## Inputs 
| Key                    | Default            | Description                                                                         |
|------------------------|--------------------|-------------------------------------------------------------------------------------|
| **php-image-tag**      | `''`               | PHP image tag to use. Takes precedence over the PHP_IMAGE_TAG environment variable. |
| **composer-cache-dir** | `/.composer/cache` | Composer cache directory.                                                           |
| **composer-home**      | `/.composer/`      | Composer home directory.                                                            |
| **no-dev**             | `false`            | Install/or not dev dependencies.                                                    |
| **gh-oauth-token**     |                    | GitHub token for pulling private dependencies.                                      |

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
