#!/bin/bash

kops create cluster \
    --name $NAME \
    --master-count 3 \
    --node-count 1 \
    --node-size t2.micro \
    --master-size t2.micro \
    --zones $ZONES \
    --master-zones $ZONES \
    --ssh-public-key devops23.pub \
    --networking kubenet \
    --kubernetes-version v1.28.4 \
    --yes

# kops delete cluster $NAME --yes

kops get cluster
kubectl cluster-info
kops validate cluster

# edit instance group
kops edit ig --name $NAME nodes
# apply edited changes:
kops update cluster --name $NAME --yes
# revert cluster changes (preview)
kops rolling-update cluster $NAME
# revert cluster changes (apply)
kops rolling-update cluster $NAME --yes

# verify local configuration
kubectl config view

# add load balancer
kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/ingress-nginx/v1.6.0.yaml
kubectl --namespace kube-ingress get all
# verify
aws elb describe-load-balancers
# get DNS
CLUSTER_DNS=$(aws elb \
    describe-load-balancers | jq -r \
    ".LoadBalancerDescriptions[] \
    | select(.DNSName \
    | contains (\"api-devops23\") \
    | not).DNSName")

# deploy applications (is the same as for minikube)
kubectl create -f aws/go-demo-2.yml --record --save-config

# get worker nodes
aws ec2 \
    describe-instances | jq -r \
    ".Reservations[].Instances[] \
    | select(.SecurityGroups[]\
    .GroupName==\"nodes.$NAME\")\
    .InstanceId"

INSTANCE_ID=$(aws ec2 \
    describe-instances | jq -r \
    ".Reservations[].Instances[] \
    | select(.SecurityGroups[]\
    .GroupName==\"nodes.$NAME\")\
    .InstanceId" | tail -n 1)

aws ec2 terminate-instances \
    --instance-ids $INSTANCE_ID

# grand permissions for others:
cd cluster
mkdir -p config
export KUBECONFIG=$PWD/config/kubecfg.yaml
kops export kubecfg --name ${NAME}
cat $KUBECONFIG

#####################################################
# safety store all envs variables
echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
export ZONES=$ZONES
export NAME=$NAME
export KOPS_STATE_STORE=$KOPS_STATE_STORE" \
    >kops

# delete cluster
kops delete cluster --name $NAME --yes
# delete bucket
aws s3api delete-bucket --bucket $BUCKET_NAME
