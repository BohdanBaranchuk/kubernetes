#!/bin/bash

# load env variables with credentials from persisted file, where kops is file with env definitions
source kops

# create S3 bucket
export BUCKET_NAME=devops23-$(date +%s)

aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --create-bucket-configuration \
    LocationConstraint=$AWS_DEFAULT_REGION

export KOPS_STATE_STORE=s3://$BUCKET_NAME

# create persistence storage
aws ec2 describe-instances \
    | jq -r \
    ".Reservations[].Instances[] \
    | select(.SecurityGroups[]\
    .GroupName==\"nodes.$NAME\")\
    .Placement.AvailabilityZone" \
    | tee zones

AZ_1=$(cat zones | head -n 1)

AZ_2=$(cat zones | tail -n 1)

# creating volumes
VOLUME_ID_1=$(aws ec2 create-volume \
    --availability-zone $AZ_1 \
    --size 10 \
    --volume-type gp2 \
    --tag-specifications "ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=$NAME}]" \
    | jq -r '.VolumeId')

VOLUME_ID_2=$(aws ec2 create-volume \
    --availability-zone $AZ_1 \
    --size 10 \
    --volume-type gp2 \
    --tag-specifications "ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=$NAME}]" \
    | jq -r '.VolumeId')

VOLUME_ID_3=$(aws ec2 create-volume \
    --availability-zone $AZ_2 \
    --size 10 \
    --volume-type gp2 \
    --tag-specifications "ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=$NAME}]" \
    | jq -r '.VolumeId')

cat pv/pv.yml \
    | sed -e \
    "s@REPLACE_ME_1@$VOLUME_ID_1@g" \
    | sed -e \
    "s@REPLACE_ME_2@$VOLUME_ID_2@g" \
    | sed -e \
    "s@REPLACE_ME_3@$VOLUME_ID_3@g" \
    | kubectl create -f - \
    --save-config --record

# claim created volume
kubectl create -f pv/pvc.yml --save-config --record

# attach claimed volumes to pods
kubectl apply -f pv/jenkins-pv.yml --record

###################
# clean up
kubectl --namespace jenkins delete deploy jenkins
# delete the persistence claim
kubectl --namespace jenkins delete pvc jenkins

aws ec2 delete-volume --volume-id $VOLUME_ID_1
aws ec2 delete-volume --volume-id $VOLUME_ID_2
aws ec2 delete-volume --volume-id $VOLUME_ID_3

aws s3api delete-bucket --bucket $BUCKET_NAME
