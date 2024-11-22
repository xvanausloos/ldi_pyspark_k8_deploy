# LDI Demo project for deploying a PySpark app to K8S cluster

Created on 22/11/24

Resource: https://medium.com/p/d886193dac3c (except TF code for infra)

## Prerequisites and stack
Terraform
AWS
EKS
PySpark
AWS CLI installed and configured (.aws/conf) 

## Step 1: deploy K8S infra in AWS
We use this : https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks

run : 
```
make deploy-infra
```

