#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${ORANGE}iioat app deployment to K3S cluster"
echo "-------------------------------------------------------------------------------${NC}"

if [ -z "$IIOS_K8S_KUBECONFIG_PATH" ]
then
  export IIOS_K8S_KUBECONFIG_PATH=/home/${USER}/.kube/config
  echo "${ORANGE}kubeconfig set to ${IIOS_K8S_KUBECONFIG_PATH}${NC}"
else
  echo "${ORANGE}kubeconfig already set to ${IIOS_K8S_KUBECONFIG_PATH}${NC}"
fi

if [ -z "$IIOS_APP_IMAGE_PULL_POLICY" ]
then
  export IIOS_APP_IMAGE_PULL_POLICY=Always
  echo "${ORANGE}app image pull policy set to ${IIOS_APP_IMAGE_PULL_POLICY}${NC}"
else
  echo "${ORANGE}app image pull policy set to ${IIOS_APP_IMAGE_PULL_POLICY}${NC}"
fi

# registry:
export IIOS_CONTAINER_REGISTRY=registry.gitlab.com/

# cluster
./k8s/cluster.sh

# ------------------------------------------------------------------------------
# Traefik ingress
# ------------------------------------------------------------------------------
echo "${YELLOW}waiting for app pods creation...${NC}"
sleep 5
kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} apply -f k8s/traefik-k8s/
