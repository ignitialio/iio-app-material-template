#!/bin/sh

kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} delete -f k8s/deploy
