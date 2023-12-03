#!/bin/bash

echo 'expose ports for replicasSet: new service name is go-demo-2-svc, type of service is NodePort'
echo 'new service is created'
echo 'this is imperative way, it is duty quick hack'
kubectl expose rs go-demo-2 --name=go-demo-2-svc --target-port=28017 --type=NodePort

echo 'get info about our service, what ports exported etc '
kubectl describe svc/go-demo-2-svc

echo 'forward the service port to the outside'
kubectl port-forward service/go-demo-2-svc 3000:28017 --address 0.0.0.0

echo 'delete service'
kubectl delete svc go-demo-2-svc

echo 'create service from the definition'
kubectl create -f go-demo-2-svc.yml

echo 'get service info'
kubectl get -f go-demo-2-svc.yml
echo 'get service info'
kubectl get ep go-demo-2 -o yaml

echo 'destroy service'
kubectl delete -f go-demo-2-svc.yml
