#!/bin/bash

echo 'get all pods, replicasSets, services, deployments'
kubectl get all

# get all clusters names
kubectl config view --minify -o jsonpath='{.clusters[].name}'


