#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${ORANGE}iioat app deployment to K3S cluster"
echo "-------------------------------------------------------------------------------${NC}"

if [ -z "$IIO_K8S_KUBECONFIG_PATH" ]
then
  IIO_K8S_KUBECONFIG_PATH=/home/${USER}/.kube/config
  echo "${ORANGE}kubeconfig set to ${IIO_K8S_KUBECONFIG_PATH}${NC}"
else
  echo "${ORANGE}kubeconfig already set to ${IIO_K8S_KUBECONFIG_PATH}${NC}"
fi

# registry:
IIOS_CONTAINER_REGISTRY=registry.gitlab.com/

# cluster
./k8s/cluster.sh

# ------------------------------------------------------------------------------
# Traefik ingress
# ------------------------------------------------------------------------------
echo "${YELLOW}waiting for app pods creation...${NC}"
sleep 5
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/traefik-k8s/
