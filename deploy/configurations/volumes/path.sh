#!/bin/bash

cp prometheus-conf.yml  ~/.minikube/files

kubectl run docker --image=docker:17.11  --restart=Never docker image ls

kubectl get pods
kubectl delete pod docker

# run from the docker definition
kubectl create -f docker.yml

kubectl exec -it docker -- docker image ls --format "{{.Repository}}"
kubectl exec docker -it -- sh

apk add -U git
git clone \
    https://github.com/Faizan-Zia/go-demo-2
cd go-demo-2
docker image build -t vfarcic/go-demo-2:beta .
docker image ls --format "{{.Repository}}"
docker system prune -f
docker image ls --format "{{.Repository}}"
exit

kubectl delete -f docker.yml
####################################################################
