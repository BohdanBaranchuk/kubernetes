#!/bin/bash

# install AWS command line
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# generate the key from aws account and use it here
export AWS_ACCESS_KEY_ID="<<KEY_ID_GET_FROM_ACCOUNT>>"
export AWS_SECRET_ACCESS_KEY="<<KEY_SECRET_GET_FROM_ACCOUNT>>" # download csv file

# set the default region
export AWS_DEFAULT_REGION=us-east-2

# create aws group
aws iam create-group --group-name kops

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops

aws iam create-user --user-name kops

aws iam add-user-to-group --user-name kops --group-name kops
aws iam create-access-key --user-name kops >kops-creds

# assign key values to the env variables. That makes us to run all commands form the kops user
export AWS_ACCESS_KEY_ID=$(\
    cat kops-creds | jq -r \
    '.AccessKey.AccessKeyId')

export AWS_SECRET_ACCESS_KEY=$(
    cat kops-creds | jq -r \
    '.AccessKey.SecretAccessKey')

# assign zone
aws ec2 describe-availability-zones --region $AWS_DEFAULT_REGION
export ZONES=$(aws ec2 \
    describe-availability-zones \
    --region $AWS_DEFAULT_REGION \
    | jq -r \
    '.AvailabilityZones[].ZoneName' \
    | tr '\n' ',' | tr -d ' ')
ZONES=${ZONES%?}
echo $ZONES

# create ssh keys
mkdir -p cluster && cd cluster
aws ec2 create-key-pair --key-name devops23 | jq -r '.KeyMaterial' >devops23.pem
chmod 400 devops23.pem
ssh-keygen -y -f devops23.pem >devops23.pub

# save the name DNS cluster
export NAME=devops23.k8s.local

# create S3 to store cluster state
export BUCKET_NAME=devops23-$(date +%s)
aws s3api create-bucket --bucket $BUCKET_NAME --create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION
# "Location": "http://devops23-1701716192.s3.amazonaws.com/"
export KOPS_STATE_STORE=s3://$BUCKET_NAME

# Installing kops
wget -O kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x ./kops
sudo mv ./kops /usr/local/bin/

