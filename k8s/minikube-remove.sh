#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${ORANGE}iioat app deployment removal from Minikube cluster"
echo "-------------------------------------------------------------------------------${NC}"

export IIO_K8S_KUBECONFIG_PATH=/home/${USER}/.kube/config
echo "${YELLOW}kubeconfig set to ${IIO_K8S_KUBECONFIG_PATH}${NC}"

kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete -f k8s/metallb/metallb-config.yaml
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml

kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete -f k8s/traefik-minikube-ingress/
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete -f k8s/traefik-minikube/
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete namespace traefik

./k8s/clean.sh

# restore /etc/hosts
# sudo mv /etc/hosts.beforekube /etc/hosts
