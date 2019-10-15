#!/bin/sh

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

echo "update app version..."
echo "app version="$IIOS_APP_VERSION
echo "auth service version="$IIOS_AUTH_VERSION
echo "dlake service version="$IIOS_DLAKE_VERSION

cat k8s/templates/app-deploy.template.yaml | sed "s/IIOS_APP_VERSION/$IIOS_APP_VERSION/g" > k8s/app/app-deploy.yaml
cat k8s/templates/services-deploy.template.yaml | sed "s/IIOS_DLAKE_VERSION/$IIOS_DLAKE_VERSION/g" | sed "s/IIOS_AUTH_VERSION/$IIOS_AUTH_VERSION/g" > k8s/app/services-deploy.yaml

# ------------------------------------------------------------------------------
# Env variables for local run
# ------------------------------------------------------------------------------
. ./k8s/set_k8s_env.sh

# ------------------------------------------------------------------------------
# Create Persistent Volume
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/pv/

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
# Redis
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/redis/

# ------------------------------------------------------------------------------
# IIO app
# ------------------------------------------------------------------------------
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
echo "${YELLOW}waiting for redis pods creation...${NC}"
sleep 10
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/app/services-deploy.yaml
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
echo "${YELLOW}waiting for services pods creation...${NC}"
sleep 5
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/app/app-deploy.yaml
echo "${YELLOW}waiting for app pods creation...${NC}"
sleep 5

# ------------------------------------------------------------------------------
# Traefik
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/traefik/
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
echo "${YELLOW}waiting for traefik pods creation...${NC}"
sleep 10

kubectl port-forward --address 0.0.0.0 service/traefik 80:8000 8080:8080 443:4443 -n default &
sleep 5

kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/traefik-ingressroutes/
