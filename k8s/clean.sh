#!/bin/sh

. ./k8s/set_k8s_env.sh

# delete
kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} delete -f k8s/deploy/app-deploy.yaml
kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} delete -f k8s/deploy/services-deploy.yaml

kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} delete -f k8s/redis/
kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} delete -f k8s/traefik/

kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} delete secret iiosecrets
kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} delete secret regcred
