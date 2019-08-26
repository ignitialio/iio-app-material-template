#!/bin/sh

# ------------------------------------------------------------------------------
# Sets app version
# ------------------------------------------------------------------------------
APP_VERSION=$(cat ./package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

echo "get app version..."
cat k8s/templates/app-deploy.template.yaml | sed "s/APP_VERSION/$APP_VERSION/g"| sed "s/DLAKE_VERSION/$DLAKE_VERSION/g" | sed "s/AUTH_VERSION/$AUTH_VERSION/g" > k8s/app/app-deploy.yaml

# ------------------------------------------------------------------------------
# Env variables for local run
# ------------------------------------------------------------------------------
. ./k8s/set_k8s_env.sh

# ------------------------------------------------------------------------------
# Labels (optional)
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} label nodes amd64-master-1 nodetype=master

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
# Certificate manager
# ------------------------------------------------------------------------------
# ...done standalone

# Issuer
# ------------------------------------------------------------------------------
# ...done standalone

# ------------------------------------------------------------------------------
# Traefik
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} create -f k8s/traefik/

# ------------------------------------------------------------------------------
# Redis
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/redis/

# ------------------------------------------------------------------------------
# IIO app
# ------------------------------------------------------------------------------
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
echo "${YELLOW}waiting for containers creation...${NC}"
sleep 20
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/app/app-deploy.yaml
