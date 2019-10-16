#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

echo "${ORANGE}iioat app deployment removal from Minikube cluster"
echo "-------------------------------------------------------------------------------${NC}"

kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete -f k8s/traefik-minikube/

./k8s/clean.sh


# minikube stop

# restore /etc/hosts
sudo mv /etc/hosts.beforekube /etc/hosts
