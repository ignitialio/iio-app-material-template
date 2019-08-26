#!/bin/sh

./k8s/clean-app.sh
./k8s/clean-redis.sh
./k8s/clean-traefik.sh

kubectl delete secret iiosecrets
kubectl delete secret regcred

# minikube stop

# restore /etc/hosts
sudo mv /etc/hosts.beforekube /etc/hosts
