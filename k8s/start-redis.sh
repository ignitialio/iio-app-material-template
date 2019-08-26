#!/bin/sh

echo "get app version..."

kubectl apply -f k8s/redis/
# kubectl apply -f ./helm/manifests/redis-ha/templates
# helm install -n iioat stable/redis-ha
