#!/bin/sh

kubectl delete -f k8s/redis/
# kubectl delete -f ./helm/manifests/redis-ha/templates
# helm delete iioat --purge
