#!/bin/bash

kubectl create -f go-demo-2-db.yml
kubectl create -f go-demo-2-db-svc.yml
kubectl create -f go-demo-2-api.yml

kubectl get -f go-demo-2-db.yml
kubectl describe -f go-demo-2-db.yml

# set image that is not working and undo changes
kubectl set image -f go-demo-2-api.yml api=vfarcic/go-demo-2:does-not-exist --record
kubectl rollout undo -f go-demo-2-api.yml
kubectl rollout status -f go-demo-2-api.yml

# clean all deployments etc
kubectl delete -f go-demo-2-db.yml
kubectl delete -f go-demo-2-db-svc.yml
kubectl delete -f go-demo-2-api.yml
