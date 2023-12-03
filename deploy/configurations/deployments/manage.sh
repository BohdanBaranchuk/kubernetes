#!/bin/bash

# assign new version for container image per deployment with template name 'db'. Record our action
kubectl set image -f go-demo-2-db.yml db=mongo:3.4 --record
# update deployments where labels matches: type=db,vendor=MongoLabs
kubectl set image deployments -l type=db,vendor=MongoLabs db=mongo:3.4 --record

# apply changes from file to the running instance
kubectl apply -f go-demo-2-db.yml

# to see what is happening during the deployment
kubectl rollout status -w -f go-demo-2-api.yml
# check the history of deployment commands
kubectl rollout history -f go-demo-2-api.yml
# roll back to the release
kubectl rollout undo -f go-demo-2-api.yml
# roll back to the some revision
kubectl rollout undo -f go-demo-2-api.yml --to-revision=2
# get rollout history
kubectl rollout history -f go-demo-2-api.yml

# set scaling
kubectl scale deployment go-demo-2-api --replicas 8 --record
