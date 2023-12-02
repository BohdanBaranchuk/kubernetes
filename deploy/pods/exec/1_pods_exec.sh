#!/bin/bash

echo 'run command ps aux inside pod container'
kubectl exec db -- ps aux

echo 'go inside container'
kubectl exec db -- sh

echo 'execute command on the few pods at the same time'
kubectl exec -it -c db go-demo-2 -- ps aux

