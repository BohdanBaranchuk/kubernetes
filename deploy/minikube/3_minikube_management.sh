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

