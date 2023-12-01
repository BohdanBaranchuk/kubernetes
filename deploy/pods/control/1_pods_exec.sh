#!/bin/bash

echo 'run command ps aux inside pod container'
kubectl exec db -- ps aux

echo 'go inside container'
kubectl exec db -- sh



