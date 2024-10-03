FROM google/cloud-sdk:495.0.0-alpine as googlecloud-cli
FROM gcr.io/kaniko-project/executor:v1.19.2 AS kaniko

FROM docker:24.0.7
LABEL com.bmeme.project.family='GKE-Docker Builder Image' \
  com.bmeme.project.version='495.0.0-24.0.7' \
  com.bmeme.maintainer.1='Daniele Piaggesi <daniele.piaggesi@bmeme.com>' \
  com.bmeme.maintainer.2='Roberto Mariani <roberto.mariani@bmeme.com>' \
  com.bmeme.refreshedat='2024-10-03'

## Add Google Cloud CLI
COPY --from=googlecloud-cli /google-cloud-sdk /google-cloud-sdk

## Add Kaniko Executor
COPY --from=kaniko /kaniko/executor /kaniko/executor
COPY --from=kaniko /kaniko/docker-credential-gcr /kaniko/docker-credential-gcr
COPY --from=kaniko /kaniko/docker-credential-ecr-login /kaniko/docker-credential-ecr-login
COPY --from=kaniko /kaniko/docker-credential-acr-env /kaniko/docker-credential-acr-env
COPY --from=kaniko /etc/nsswitch.conf /etc/nsswitch.conf
COPY --from=kaniko /kaniko/.docker /kaniko/.docker

ENV PATH="${PATH}:/google-cloud-sdk/bin:/usr/local/bin:/kaniko"
ENV DOCKER_CONFIG /kaniko/.docker/

## Add scripts
COPY scripts/common.sh /root/common.sh
COPY scripts/authenticate.sh /usr/bin/authenticate

RUN set -eux; \
  chmod u+x /usr/bin/authenticate; \
  \
  apk add --no-cache curl python3 build-base docker-compose git; \
  \
  gcloud config set core/disable_usage_reporting true; \
  gcloud config set component_manager/disable_update_check true; \
  gcloud config set metrics/environment github_docker_image
