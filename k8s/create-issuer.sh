#!/bin/sh

. ./k8s/set_k8s_env.sh

# Create issuer in a given namespace
kubectl --kubeconfig ${IIO_K8S_KUBECONFIG_PATH} create -n cert-manager -f k8s/cert-manager/issuer.yaml
