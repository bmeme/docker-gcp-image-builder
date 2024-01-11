#!/bin/sh

source /root/common.sh

info "${GREEN} Validating variables ${RESET}"

if [[ -z "${GCP_SERVICE_ACCOUNT}" ]]; then
  empty_variable GCP_SERVICE_ACCOUNT
fi

if [[ -z "${GCP_REGISTRY_HOST}" ]]; then
  empty_variable GCP_REGISTRY_HOST
fi

if [[ ${error_code} != 0 ]]; then
  exit ${error_code}
fi

echo ${GCP_SERVICE_ACCOUNT} > /tmp/gcloud-service-key.json
gcloud auth activate-service-account --key-file /tmp/gcloud-service-key.json
gcloud auth configure-docker --quiet ${GCP_REGISTRY_HOST}
