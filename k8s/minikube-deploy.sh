#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

echo "${ORANGE}iioat app deployment to Minikube cluster"
echo "-------------------------------------------------------------------------------${NC}"

export IIO_K8S_KUBECONFIG_PATH=/home/${USER}/.kube/config
echo "${ORANGE}kubeconfig set to ${IIO_K8S_KUBECONFIG_PATH}${NC}"

MINIKUBE_STATUS=$(minikube status | grep Running)
echo "MINIKUBE_STATUS=<$MINIKUBE_STATUS>"

if [ -z "$MINIKUBE_STATUS" ]
then
  minikube start
else
  echo "${ORANGE}minikube started${NC}"
fi

# make a copy of /etc/hosts
sudo cp /etc/hosts /etc/hosts.beforekube

# cluster
./k8s/cluster.sh

# ------------------------------------------------------------------------------
# Traefik ingress
# ------------------------------------------------------------------------------
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
echo "${YELLOW}waiting for app pods creation...${NC}"
sleep 5
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/traefik-minikube/

# declare local domain/host for traefik routing
# WARNGING: DON'T FORGET TO CLEAN UP
echo "$(minikube ip) iioat.minikube" | sudo tee -a /etc/hosts

# Manual
# kubectl get pods
# kubectl exec redis-59b74576b6-vwsn4 -- printenv | grep SERVICE

# kubectl port-forward deployment/redis 6379:6379 &
