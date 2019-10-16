#!/bin/sh

. ./k8s/set_k8s_env.sh

# delete
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete -f k8s/deploy/app-deploy.yaml
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete -f k8s/deploy/services-deploy.yaml

kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete -f k8s/redis/
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete -f k8s/traefik/

kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete secret iiosecrets
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} delete secret regcred
