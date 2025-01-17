**Infrastructure**

Based on my understanding with the requirement, I have created below architecture,

![alt text](https://github.com/girishpatil795/aws-infra/blob/main/Architecture/aws-eks.jpg?raw=true)


Configured below to support the required architecture,<br />

. VPC<br />
. Subnets <br />
. Internet Gateway <br />
. NAT Gateway <br />
. Route Tables <br />
. EKS <br />
. NodeGroup <br />

Created VPC, Internet Gateway and attached IGW to the VPC.<br />
Created  2 public subnets and public route tables connected to above internet gateway. Public subnets are created to facilitate the incoming external traffic.<br />
Created 2 NAT Gateways with elastic IPs and mapped these 2 NAT Gateways to the public subnets. <br />
Created 2 private subnets to host EKS worker nodes and the necessary applications. Created 2 private route tables and added the route through respective NAT Gateway and associated private route tables to the respective private subnets.<br />
Provisioned EKS with 1 VPC, 4 subnets (2 public and 2 private), required IAM roles, NAT Gateways and IGW following the below structure,<br />

**Terraform Structure** <br />
I have used Terraform as the IAC tool with below structure,<br />
Created 2 folders, Modules and ToDo-App.<br />
Modules contain all the necessary resources created separately, we can still isolate the resource modules if needed .<br />
ToDo-App is the project name that is used to provision EKS and it uses the modules defined above to provision the infra.<br />

I have also included the K8s yamls files in the same repo, however in actual use case, we will create separate repo to maintain application related code.


**K8s Applications** 
Created a deployment to host webapp with container image **kennethreitz/httpbin** (assuming that the image is available publicly) and with 2 replicas.<br />
Created a service to expose the webapp with service type as ClusterIP.<br />
Created ingress rule to allow external traffic with only **/get** and the ingress routes the requests to the associated service that inturn route the requests to webapp.<br /> . 
We will be utilizing aws load balancer controller to route the external traffic to ingress. Install aws load balancer using helm as mentioned in text file under k8s-resources directory,<br />
Internal user can perform /post requests with using https://<ClusterIP>/post . In order to facilitate using of hostname instead of IP, I have Configured Ingress with /post https://myapp.webapp.com/post that uses internal nginx ingress controller.<br />

**Flow of Traffic** <br />
An external request to https://myapp.webapp.com/get will first hit the IGW -->ALB-->Ingress-->Service-->Pod

A request to https://myapp.webapp.com/post will first hit the Ingress-->Service-->Pod and a request to https://<ClusterIP>/post will hit Service-->Pod


**Assumptions** <br />

Assuming that Nginx Ingress Controller has already been deployed. I have not covered deploying Ingress controller.<br />
secret myapp-tls-secret is created with tls certificate <br />


**Logging and Monitoring** <br />

Will deploy prometheus and grafana in the EKS cluster and use Prometheus to collect the metrics from all the K8s resources and prometheus offers flexible query language for extracting insights from the metrics.
Then, will integrate Prometheus with Grafana for dashboards and alerting.<br />

Alternatively, we can also use Sysdig that offers Kubernetes monitoring and security capabilities.<br /> 
It provides detailed visibility into the containers, microservices, and applications, helping to detect and respond to security threats and performance issues.
