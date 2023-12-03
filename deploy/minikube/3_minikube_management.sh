#!/bin/bash

echo 'start minikube dashboard'
minikube dashboard
# http://127.0.0.1:46563/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/workloads?namespace=default

minikube pause
minikube unpause
minikube stop

echo 'Change the default memory limit'
minikube config set memory 9001

echo 'delete all clusters'
minikube delete --all
echo 'or clusters could be deleted with'
minikube delete

# destroy all in cluster
minikube cluster delete minukube --all

# enable ingress
minikube addons enable ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml
