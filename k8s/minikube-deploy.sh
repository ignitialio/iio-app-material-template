#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${ORANGE}iioat app deployment to Minikube cluster"
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
  echo "${ORANGE}minikube already started${NC}"
fi

# declare local domain/host for traefik routing
# make a copy of /etc/hosts
# sudo cp /etc/hosts /etc/hosts.beforekube
# WARNGING: DON'T FORGET TO CLEAN UP if next line uncommented
# echo "$(minikube ip) iioat.minikube" | sudo tee -a /etc/hosts
echo "${RED}---minikube ip: $(minikube ip)${NC}"

export IIOS_IMAGE_PULL_POLICY=IfNotPresent
echo "${YELLOW}app image pull policy set to ${IIOS_IMAGE_PULL_POLICY}${NC}"

# ------------------------------------------------------------------------------
# Cluster deploy (core)
# ------------------------------------------------------------------------------
./k8s/cluster.sh

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------
if [ -z "$IIOS_TEST_DEPLOY" ]
then
  kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} apply -f k8s/test/
fi

if [ -z "$IIOS_USE_TRAEFIK" ]
then
  # ------------------------------------------------------------------------------
  # Traefik ingress
  # ------------------------------------------------------------------------------
  kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} apply -f k8s/traefik-minikube/
  kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} apply -f k8s/traefik-minikube-ingress/
else
  # ------------------------------------------------------------------------------
  # Nginx ingress
  # ------------------------------------------------------------------------------
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
