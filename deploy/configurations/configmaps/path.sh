#!/bin/bash

# create config map like copy of file
kubectl create cm my-config --from-file=prometheus-conf.yml

# get details about config
kubectl describe cm my-config

# create pod with defined config map
kubectl create -f alpine.yml

kubectl get pods

# verify that config was mounted
kubectl exec -it alpine -- ls /etc/config
kubectl exec -it alpine -- ls -l /etc/config

# remove the pod
kubectl delete -f alpine.yml
# remove config map
kubectl delete cm my-config

########################################################
# create config map from few files:
kubectl create cm my-config --from-file=cm/prometheus-conf.yml --from-file=cm/prometheus.yml

# create config map from directory
kubectl create cm my-config --from-file=cm

# create config map from literals (could be not used at all because creates separate files per literal)
kubectl create cm my-config --from-literal=something=else --from-literal=weather=sunny
kubectl get cm my-config -o yaml

########################################################

# create config map from env file
kubectl create cm my-config --from-env-file=my-env-file.yml
kubectl get cm my-config -o yaml
kubectl delete cm my-config

kubectl create -f alpine-env.yml
kubectl delete -f alpine-env.yml
