#!/bin/bash

# get all namespaces
kubectl get ns

# get object form some namespace
kubectl --namespace kube-public get all
# where --namespace kube-public - should be used with all commands for this namespace

# create new namespace
kubectl create ns testing

# get all clusters with context info
kubectl config view
# default context is minikube and the same namespace

# create new context with namespace testing
kubectl config set-context testing --namespace testing --cluster minikube --user minikube

# switch the context
kubectl config use-context testing

# comminication between namespaces: <service_name>.<name_space>, where testing - is namespace
kubectl exec -it test -- curl "http://go-demo-2-api.testing:8080/demo/hello"

# cascading delete namespace with all created inside objects
kubectl delete ns testing
# verify
kubectl -n testing get all

