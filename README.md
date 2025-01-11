**Infrastructure**

Based on the understanding, I have created below architecture,

![alt text](https://github.com/girishpatil795/aws-infra/blob/main/Architecture/aws-eks.jpg?raw=true)


Configured below to support the required architecture,

. VPC
. Subnets 
. Internet Gateway
. NAT Gateway
. Route Tables
. EKS
. NodeGroup

Created VPC, Internet Gateway and attached IGW to the VPC.

Created  2 public subnets and public route tables connected to above internet gateway. Public subnets are created to facilitate the incoming external traffic.

Created 2 NAT Gateways with elastic IPs and mapped these 2 NAT Gateways to the public subnets. 

Created 2 private subnets to host EKS worker nodes and the necessary applications. Created 2 private route tables and added the route through respective NAT Gateway and associated private route tables to the respective private subnets.

Provisioned EKS with 1 VPC, 4 subnets (2 public and 2 private), required IAM roles, NAT Gateways and IGW following the below structure,

**Terraform Structure** 
I have used Terraform as the IAC tool with below structure,
Created 2 folders, Modules and ToDo-App.
Modules contain all the necessary resources created separately, we can still isolate the resource modules if needed .
ToDo-App is the project name that is used to provision EKS and it uses the modules defined above to provision the infra.

I have also included the K8s yamls files in the same repo, however in actual use case, we will create separate repo to maintain application related code.


**K8s Applications** 
Created a deployment to host webapp with container image kennethreitz/httpbin (assuming that the image is available publicly) and with 2 replicas.
Created a service to expose the webapp with service type as ClusterIP.
Created ingress rule to allow external traffic with only /get and the ingress routes the requests to the associated service that inturn route the requests to webapp.
Internal user can perform /post requests with using https://<ClusterIP>/post

**Flow of Traffic**
An external request to https://mapp.webapp.com/get will first hit the IGW -->ALB-->Ingress-->Service-->Pod

A request to https://mapp.webapp.com/post will first hit the Ingress-->Service-->Pod


