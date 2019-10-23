#!/bin/sh

kubectl --kubeconfig ${IIOS_K8S_KUBECONFIG_PATH} apply -f k8s/deploy
