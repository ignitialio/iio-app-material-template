#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${ORANGE}iioat app deployment removal from K3S cluster"
echo "-------------------------------------------------------------------------------${NC}"

kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete -f k8s/traefik-k8s/

./k8s/clean.sh
