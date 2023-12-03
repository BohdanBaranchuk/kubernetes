#!/bin/bash

kubectl create -f go-demo-2.yml

kubectl get -f go-demo-2.yml

# forward port to outside
nohup kubectl port-forward service/go-demo-2-api --address 0.0.0.0  3000:8080 > /dev/null 2>&1 &

# test
curl -i "http://localhost:3000/demo/hello"

