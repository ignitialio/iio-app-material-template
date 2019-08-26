#!/bin/sh

kubectl apply -f k8s/traefik/traefik-rbac.yaml
kubectl apply -f k8s/minikube-traefik/

# one by one
# kubectl apply -f minikube-traefik-ds.yaml
# kubectl apply -f minikube-traefik-ingress.yaml
