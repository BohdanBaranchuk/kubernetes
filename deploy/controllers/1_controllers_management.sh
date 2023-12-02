#!/bin/bash

echo 'get the list of replicas in the cluster'
kubectl run get rs

echo 'get the list of replicas defined in the file'
kubectl get -f go-demo-2.yml

kubectl describe -f go-demo-2.yml
