#!/bin/bash

# enable ingress
nohup kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 3000:80 --address 0.0.0.0 > /dev/null 2>&1 &

# Check if ingress working
curl -i "0.0.0.0:3000/healthz"

kubectl create -f go-demo-2-ingress.yml
kubectl get -f go-demo-2-ingress.yml

kubectl delete -f go-demo-2-ingress.yml



kubectl create -f go-demo-2.yml --record --save-config

nohup kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 3000:80 --address 0.0.0.0 > /dev/null 2>&1 &
curl -i "http://0.0.0.0:3000/demo/hello"
kubectl delete -f go-demo-2.yml

# add second forwarding for ingress
kubectl create -f devops-toolkit.yml --record --save-config
kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 3000:80 --address 0.0.0.0  > /dev/null 2>&1 &

# add host based forwarding for ingress
kubectl apply -f devops-toolkit-dom.yml --record
# this is new forwarding
curl -I -H "Host: devopstoolkitseries.com" "http://0.0.0.0:3000"
# this is prev forwarding
curl -H "Host: acme.com" "http://0.0.0.0:3000/demo/hello"

# add default resource
kubectl create -f default-backend.yml
curl -I -H "Host: acme.com" "http://0.0.0.0:3000"
