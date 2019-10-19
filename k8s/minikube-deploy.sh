#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${ORANGE}-------------------------------------------------------------------------------"
echo "iioat app deployment to Minikube cluster"
echo "-------------------------------------------------------------------------------${NC}"

# ------------------------------------------------------------------------------
# Prepare
# ------------------------------------------------------------------------------
export IIOS_K8S_KUBECONFIG_PATH=/home/${USER}/.kube/config
echo "${YELLOW}kubeconfig set to ${IIOS_K8S_KUBECONFIG_PATH}${NC}"

MINIKUBE_STATUS=$(minikube status | grep Running)
# echo "MINIKUBE_STATUS=<$MINIKUBE_STATUS>"

if [ -z "$MINIKUBE_STATUS" ]
then
  minikube start
else
  echo "${YELLOW}minikube already started${NC}"
fi

export IIOS_IMAGE_PULL_POLICY=IfNotPresent
echo "${YELLOW}app image pull policy set to ${IIOS_IMAGE_PULL_POLICY}${NC}"

# ------------------------------------------------------------------------------
# Cluster deploy (core)
# ------------------------------------------------------------------------------
./k8s/cluster.sh

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------
if [ "$IIOS_TEST_DEPLOY" = true ]
then
  kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} apply -f k8s/test/
fi

if [ "$IIOS_USE_TRAEFIK" = true ]
then
  # ------------------------------------------------------------------------------
  # Traefik ingress
  # ------------------------------------------------------------------------------
  echo "${RED}TRAEFIK ingress selected${NC}"
  kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} apply -f k8s/traefik-minikube/
  kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} apply -f k8s/traefik-minikube-ingress/
else
  # ------------------------------------------------------------------------------
  # Nginx ingress
  # ------------------------------------------------------------------------------
  echo "${RED}NGINX ingress selected${NC}"
  kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} apply -f k8s/ingress-minikube/
fi

# ------------------------------------------------------------------------------
# Load balancer
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} apply -f k8s/metallb/metallb-config.yaml

# Manual
# kubectl get pods
# kubectl exec redis-59b74576b6-vwsn4 -- printenv | grep SERVICE

# kubectl port-forward deployment/redis 6379:6379 &
