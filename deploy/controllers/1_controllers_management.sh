#!/bin/bash

echo 'create replicasSet wit save config'
kubectl create -f container_controled_pods.yml --save-config

echo 'get the list of replicas in the cluster'
kubectl run get rs

echo 'get the list of replicas defined in the file'
kubectl get -f go-demo-2.yml

kubectl describe -f go-demo-2.yml

echo 'delete replicasSet with all assigned to it pods'
kubectl delete -f go-demo-2.yml

echo 'delete replicasSet without pods'
kubectl delete -f go-demo-2.yml --cascade=orphan
