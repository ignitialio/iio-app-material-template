#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${ORANGE}iioat app deployment db populate (Redis + DB as per manifest configuration)"
echo "-------------------------------------------------------------------------------${NC}"

# ------------------------------------------------------------------------------
# Prepare
# ------------------------------------------------------------------------------
mkdir -p ./k8s/deploy

# sets app versions
IIOS_APP_VERSION=$(cat ./package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

echo "update versions and endpoints..."
echo "app version="$IIOS_APP_VERSION
echo "container registry="$IIOS_CONTAINER_REGISTRY

cat k8s/templates/app-populate.template.yaml | sed "s/IIOS_CONTAINER_REGISTRY/$IIOS_CONTAINER_REGISTRY/g" | sed "s/IIOS_APP_VERSION/$IIOS_APP_VERSION/g" > k8s/deploy/app-populate.yaml

# ------------------------------------------------------------------------------
# Env variables for local run
# ------------------------------------------------------------------------------
. ./k8s/set_k8s_env.sh

# ------------------------------------------------------------------------------
# Create Persistent Volume
# ------------------------------------------------------------------------------
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} apply -f k8s/pv/

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

# wait for redis
echo "${ORANGE}wait for redis ready...${NC}"
sleep 5

echo "${ORANGE}start iioat container...${NC}"

# start app
kubectl apply -f k8s/deploy/app-populate.yaml

# wait for job to be completed
kubectl wait --for=condition=complete --timeout=600s job/iioat-populate

echo "${ORANGE}save logs to [tools/logs/populate-atlas.log]...${NC}"

# save and show logs
kubectl logs job/iioat-populate > tools/logs/k8s-populate.log
kubectl logs job/iioat-populate

# delete populate job
kubectl delete -f k8s/deploy/app-populate.yaml

# delete redis
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete -f k8s/redis/

# delete secrets
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete secret iiosecrets
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete secret regcred
