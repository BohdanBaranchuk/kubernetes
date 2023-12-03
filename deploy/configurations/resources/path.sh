#!/bin/bash

kubectl create -f go-demo-2-random.yml --record --save-config

kubectl rollout status deployment go-demo-2-api

kubectl describe deploy go-demo-2-api

# get the consuming resources values based on the metrics. Metrics should be enabled
kubectl top pods

###########################################
# create namespace with limits per container
kubectl create ns test
kubectl --namespace test create -f limit-range.yml --save-config --record
kubectl describe namespace test

kubectl --namespace test apply -f go-demo-2.yml --record
kubectl --namespace test get events --watch

kubectl delete namespace test

###########################################
# create namespace with total quotas per namespace
kubectl create ns dev
kubectl create -f dev.yml --record --save-config
kubectl --namespace dev describe quota dev
kubectl delete namespace dev
