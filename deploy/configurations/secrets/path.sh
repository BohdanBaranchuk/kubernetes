#!/bin/bash

kubectl create secret generic my-creds --from-literal=username=jdoe --from-literal=password=incognito
# Secrets can use --from-env-file, --from-file, and --from-literal

kubectl get secrets
kubectl get secret my-creds -o json
# get decoded values
kubectl get secret my-creds -o jsonpath="{.data.username}" | base64 --decode
