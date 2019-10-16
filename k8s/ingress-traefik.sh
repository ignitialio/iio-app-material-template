#!/bin/sh

# ------------------------------------------------------------------------------
# Traefik
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/traefik/
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
echo "${YELLOW}waiting for traefik pods creation...${NC}"
sleep 10

# ------------------------------------------------------------------------------
# Port forwarding to get LE connexion
# ------------------------------------------------------------------------------
kubectl port-forward --address 0.0.0.0 service/traefik 80:8000 8080:8080 443:4443 -n default &
sleep 5

# ------------------------------------------------------------------------------
# Ingress routes
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/traefik-ingressroutes/
