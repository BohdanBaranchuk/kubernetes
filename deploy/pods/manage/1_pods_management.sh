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
echo 'print pods with info about labels for them'
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

echo 'delete the last pod'
POD_NAME=$(kubectl get pods -o name | tail -1)
echo 'pod to be deleted: ' + $POD_NAME
kubectl delete $POD_NAME


echo 'delete label service from the pod'
POD_NAME=$(kubectl get pods -o name | tail -1)
kubectl label $POD_NAME service-
kubectl describe $POD_NAME

echo 'add label service to the pod'
POD_NAME=$(kubectl get pods -o name | tail -1)
kubectl label $POD_NAME service=go-demo-2
kubectl describe $POD_NAME
