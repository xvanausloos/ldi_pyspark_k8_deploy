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
An EKS cluster is provisioned.

### Configure kubectl

Run the following command to retrieve the access credentials for your cluster and configure kubectl.
```
aws --region your-region eks update-kubeconfig --name your-cluster-name
```

aws --region us-east-1 eks update-kubeconfig --name ldi-pyspark-eks-KaifRtIp

### Check nodes 
```
kubectl get nodes
```

## Step 2: Installing the Spark Operator

Install the Spark K8S operator
See https://github.com/kubeflow/spark-operator/tree/master/charts/spark-operator-chart

```
helm repo add spark-operator https://kubeflow.github.io/spark-operator

helm repo update
```

Install it: 
```
helm install spark-operator spark-operator/spark-operator \
    --namespace spark-operator \
    --create-namespace
```

Check pods:
```
kubens spark-operator 
kubectl get pods
```

## Step 3: Running a PySpark app
Now we can finally run python spark apps in K8s. The first thing we need to do is to create a spark user, in order to give the spark jobs, access to the Kubernetes resources. We create a service account and a cluster role binding for this purpose:

### Create the role for Spark
Create a folder `spark` and add a file `spark-rbac.yaml`

Add this in this file: 

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: spark
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: spark-role
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: edit
subjects:
  - kind: ServiceAccount
    name: spark
    namespace: default
```

Create this role:
`kubectl apply -f spark/spark-rbac.yml`

### Create the spark operator job definition

```
apiVersion: "sparkoperator.k8s.io/v1beta2"
kind: SparkApplication
metadata:
  name: spark-job
  namespace: default
spec:
  type: Python
  pythonVersion: "3"
  mode: cluster
  image: "uprush/apache-spark-pyspark:2.4.5"
  imagePullPolicy: Always
  mainApplicationFile: local:////opt/spark/examples/src/main/python/pi.py
  sparkVersion: "2.4.5"
  restartPolicy:
    type: OnFailure
    onFailureRetries: 2
  driver:
    cores: 1
    memory: "1G"
    labels:
      version: 2.4.5
    serviceAccount: spark
  executor:
    cores: 1
    instances: 1
    memory: "1G"
    labels:
      version: 2.4.5
```

Submit the Spark job (Pi in this example already available in the Docker image)

`kubectl apply -f spark/spark-job.yaml`
