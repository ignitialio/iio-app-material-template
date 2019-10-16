#!/bin/sh

export IIO_K8S_SECRETS_PATH=/home/${USER}/data/app-secrets.yaml
echo "Sets IIO_K8S_SECRETS_PATH to ${IIO_K8S_SECRETS_PATH}"
export IIO_K8S_REGISTRY_CONFIG_PATH=/home/${USER}/.docker/config.json
echo "Sets IIO_K8S_REGISTRY_CONFIG_PATH to ${IIO_K8S_REGISTRY_CONFIG_PATH}"
