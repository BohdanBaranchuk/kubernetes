#!/bin/bash


# get the config about what API port used by cluster
kubectl config view
# https://localhost:36219/

# Get the port for minikube cluster
kubectl config view -o jsonpath='{.clusters[?(@.name=="minikube")].cluster.server}'

# Get the certificates for minikube cluster
kubectl config view -o jsonpath='{.clusters[?(@.name=="minikube")].cluster.certificate-authority}'


# just a test
kubectl create -f go-demo-2.yml --record --save-config

#############################################################
# Create certificate for the user

# create a private key
mkdir keys
openssl genrsa -out keys/jdoe.key 2048
# generate certificate from key
openssl req -new -key keys/jdoe.key -out keys/jdoe.csr -subj "/CN=jdoe/O=devs"
# generate the final certificate with authority
ls -1 ~/.minikube/ca.*
openssl x509 -req \
    -in keys/jdoe.csr \
    -CA /home/atom/.minikube/ca.crt -CAkey /home/atom/.minikube/ca.key -CAcreateserial -out keys/jdoe.crt -days 365
# copy cluster autority
cp /home/atom/.minikube/ca.crt keys/

#The new certificate (jdoe.crt)
#The key (jdoe.key)
#The cluster authority (ca.crt)
#The address of the server,

#############################################################
# Configure the cluster to use above authority

SERVER=$(kubectl config view -o jsonpath='{.clusters[?(@.name=="minikube")].cluster.server}')
echo $SERVER

# create new cluster
kubectl config set-cluster jdoe --certificate-authority keys/ca.crt --server $SERVER
# create credentials for the cluster
kubectl config set-credentials jdoe --client-certificate keys/jdoe.crt --client-key keys/jdoe.key
# create context for cluster
kubectl config set-context jdoe --cluster jdoe --user jdoe
# switch to context
kubectl config use-context jdoe
kubectl config view

# to check if action could be perfomed from the user john
kubectl auth can-i get pods --as jdoe

# get all roles
kubectl get roles
kubectl get clusterroles
# describe the details about roles that could have a view rights
kubectl describe clusterrole view
# describe the details about roles that could have a edit rights
kubectl describe clusterrole edit


# bind a user to the role, allow for jdoe view all in default namespace
kubectl create rolebinding jdoe --clusterrole view --user jdoe --namespace default --save-config
# check
kubectl auth can-i get pods --as jdoe
kubectl auth can-i get pods --as jdoe --all-namespaces
# delete
kubectl delete rolebinding jdoe


# make role binding from the file
kubectl create -f crb-view.yml --record --save-config
