#!/bin/bash

echo 'run the pod with name db'
kubectl run db --image mongo

echo 'get pods list'
kubectl get pods
echo 'get pods list with details'
kubectl get pods -o wide
echo 'get pods list with details in json format'
kubectl get pods -o json
echo 'print only name from json section containers in output'
kubectl get -f deploy/pods/configurations/few_containers_for_pod.yml -o jsonpath="{.spec.containers[*].name}"
echo 'print pods with info about them'
kubectl get pods --show-labels

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
