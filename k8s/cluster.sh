#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ------------------------------------------------------------------------------
# Prepare
# ------------------------------------------------------------------------------
mkdir -p k8s/deploy

# ------------------------------------------------------------------------------
# Sets app version
# ------------------------------------------------------------------------------
IIOS_APP_VERSION=$(cat ./package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

IIOS_AUTH_VERSION=1.0.3
IIOS_DLAKE_VERSION=3.0.5

echo "update versions and endpoints..."
echo "app version="$IIOS_APP_VERSION
echo "auth service version="$IIOS_AUTH_VERSION
echo "dlake service version="$IIOS_DLAKE_VERSION
echo "container registry="$IIOS_CONTAINER_REGISTRY

cat k8s/templates/app-deploy.template.yaml | sed "s/IIOS_IMAGE_PULL_POLICY/$IIOS_IMAGE_PULL_POLICY/g" | sed "s/IIOS_CONTAINER_REGISTRY/$IIOS_CONTAINER_REGISTRY/g" | sed "s/IIOS_APP_VERSION/$IIOS_APP_VERSION/g" > k8s/deploy/app-deploy.yaml
cat k8s/templates/services-deploy.template.yaml | sed "s/IIOS_DLAKE_VERSION/$IIOS_DLAKE_VERSION/g" | sed "s/IIOS_AUTH_VERSION/$IIOS_AUTH_VERSION/g" > k8s/deploy/services-deploy.yaml

# ------------------------------------------------------------------------------
# Env variables for local run
# ------------------------------------------------------------------------------
. ./k8s/set_k8s_env.sh

# ------------------------------------------------------------------------------
# Create Persistent Volume
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/pv/

# ------------------------------------------------------------------------------
# Docker registry
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} create secret generic regcred \
    --from-file=.dockerconfigjson=${IIO_K8S_REGISTRY_CONFIG_PATH} \
    --type=kubernetes.io/dockerconfigjson

# ------------------------------------------------------------------------------
# Secrets
# ------------------------------------------------------------------------------
# create K8S secrets from credential file
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} create -f $IIO_K8S_SECRETS_PATH

# ------------------------------------------------------------------------------
# Redis
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/redis/
echo "${YELLOW}waiting for redis pods creation...${NC}"
sleep 10

# ------------------------------------------------------------------------------
# IIO app
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/deploy/services-deploy.yaml
echo "${YELLOW}waiting for services pods creation...${NC}"
sleep 5
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/deploy/app-deploy.yaml
