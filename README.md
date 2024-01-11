[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

GCP IMAGE BUILDER
=====

OCI image, based on the official [Docker image](https://hub.docker.com/_/docker) and integrated with [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) and [Kaniko Executor](https://github.com/GoogleContainerTools/kaniko), currently being used in Bmeme for Continuous Integration and Delivery.

## What is contained in the images
* Google Cloud SDK
* Docker
* Kaniko
* build-base tools
* python 3.11
* docker-compose (for backward compatibility)
* A script `authenticate` that wraps authentication tasks against Google Cloud and Google Artifact Registry

## Mandatory environments
| Variable Name | Description |
|---------------|-------------|
|`GCP_SERVICE_ACCOUNT`| The json key of the Google Service Account granted|
|`GCP_REGISTRY_HOST`| Your Google Cloud Artifact Registry host |

## Scripts

### Authentication
Set mandatory enviroments, then:

```
# /usr/bin/authenticate
```

## How to use it in a `.gitlab-ci.yml` pipeline
```
image: bmeme/gcp-image-builder:latest

stages:
  - build
  - package

variables:
  GCP_PROJECT_ID: my-gcp-project
  GCP_REGISTRY_HOST: europe-docker.pkg.dev #for example

before_script:
  - /usr/bin/authenticate

build:
  stage: build
  script:
    - docker compose up -d

package:
  stage: package
  script:
    - |
      kaniko/executor \
        --dockerfile=/path/to/my/Dockerfile \
        --destination=${GCP_REGISTRY_HOST}/${GCP_PROJECT_ID}/my-repo-name/my-image:1.0.0 \
        --destination=${GCP_REGISTRY_HOST}/${GCP_PROJECT_ID}/my-repo-name/my-image:latest \
        --cache=true \
        --cache-repo=${GCP_REGISTRY_HOST}/${GCP_PROJECT_ID}/my-repo-name/my-image/cache
```