#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

export IIO_K8S_SECRETS_PATH=/home/${USER}/data/app-secrets.yaml
echo "${YELLOW}Sets IIO_K8S_SECRETS_PATH to ${IIO_K8S_SECRETS_PATH}${NC}"
export IIO_K8S_REGISTRY_CONFIG_PATH=/home/${USER}/.docker/config.json
echo "${YELLOW}Sets IIO_K8S_REGISTRY_CONFIG_PATH to ${IIO_K8S_REGISTRY_CONFIG_PATH}${NC}"
