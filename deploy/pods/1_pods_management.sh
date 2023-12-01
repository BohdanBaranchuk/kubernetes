#!/bin/bash

echo 'run the pod with name db'
kubectl run db --image mongo

echo 'get pods list'
kubectl get pods
echo 'get pods list with details'
kubectl get pods -o wide
echo 'get pods list with details in json format'
kubectl get pods -o json

echo 'delete pod'
kubectl delete pod db

echo 'create pod from the configuration'
kubectl create -f configurations/db.yml

echo 'get pod details based on the pod name from config file'
kubectl describe -f configurations/db.yml

echo 'get the logs'
kubectl logs db

echo 'delete the pod'
kubectl delete -f deploy/pods/configurations/db.yml
