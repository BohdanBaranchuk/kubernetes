#!/bin/bash

echo 'run command ps aux inside pod container'
kubectl exec db -- ps aux

echo 'go inside container'
kubectl exec db -- sh

echo 'execute command on the few pods at the same time'
kubectl exec -it -c db go-demo-2 -- ps aux

# get env variables
POD_NAME=$(kubectl get pod --no-headers -o=custom-columns=NAME:.metadata.name -l type=db,service=go-demo-2 | tail -1)
kubectl exec $POD_NAME -- env
