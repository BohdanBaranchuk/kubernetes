#!/bin/bash

# source: https://minikube.sigs.k8s.io/docs/start/

echo 'download minikube'
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
echo install minikube
sudo install minikube-linux-amd64 /usr/local/bin/minikube
echo 'finished kubectl install'

echo 'download kubectl'
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
echo 'validate downloaded kubectl'
echo 'get remote checksum'
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo 'get installed checksum'
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
echo 'install kubectl'
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo 'test installed kubectl'
kubectl version --client
