#!/bin/bash

# without persistent state
kubectl create \
    -f jenkins.yml \
    --record --save-config

kubectl rollout status deploy jenkins

POD_NAME=$(kubectl get pods \
    -l service=jenkins,type=master \
    -o jsonpath="{.items[*].metadata.name}")

# with persistent state
kubectl apply \
    -f jenkins-empty-dir.yml

kubectl rollout status deploy jenkins

POD_NAME=$(kubectl get pods \
    -l service=jenkins,type=master \
    -o jsonpath="{.items[*].metadata.name}")

kubectl exec -it $POD_NAME kill 1

kubectl get pods
