#!/bin/sh

kubectl delete -f k8s/minikube-traefik/
# one by one
# kubectl delete -f minikube-traefik-ds.yaml
# kubectl delete -f minikube-traefik-ingress.yaml
kubectl delete -f k8s/traefik/traefik-rbac.yaml
