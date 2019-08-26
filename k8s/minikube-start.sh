#!/bin/sh

RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

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

# sets app versions
export APP_VERSION=$(cat ./package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

export AUTH_VERSION=1.0.2
export DLAKE_VERSION=3.0.3

echo "set app version (APP_VERSION=${APP_VERSION})..."
cat k8s/templates/minikube-app-deploy.template.yaml | sed "s/APP_VERSION/$APP_VERSION/g" | sed "s/DLAKE_VERSION/$DLAKE_VERSION/g" | sed "s/AUTH_VERSION/$AUTH_VERSION/g" > k8s/app/minikube-app-deploy.yaml

# cluster start

. ./k8s/set_k8s_env.sh

# docker registry
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=${IIO_K8S_REGISTRY_CONFIG_PATH} \
    --type=kubernetes.io/dockerconfigjson

# create K8S secrets from credential file
./k8s/secrets.sh

# start traefik
./k8s/start-traefik.sh

# start Redis
./k8s/start-redis.sh

# wait for redis
echo "wait for redis ready..."
sleep 5

# start app
./k8s/start-app.sh

# declare local domain/host for traefik routing
# WARNGING: DON'T FORGET TO CLEAN UP
echo "$(minikube ip) iioat.minikube" | sudo tee -a /etc/hosts

# Manual
# kubectl get pods
# kubectl exec redis-59b74576b6-vwsn4 -- printenv | grep SERVICE

# kubectl port-forward deployment/redis 6379:6379
