AWS-ALB-EC2-Terraform-Stack
AWS ALB & EC2 Terraform Stack
This project automates the deployment of an Application Load Balancer (ALB) and a set of EC2 Instances within a custom VPC using Terraform and Jenkins.

🏗️ Infrastructure Overview
VPC: Custom network with Public and Private subnets.

ALB: Distributes traffic across EC2 instances in multiple Availability Zones.

EC2: Linux instances running a web server (configured via userdata).

Security Groups: Controlled access to port 80 (HTTP) and 22 (SSH).

🚀 How to Run This Code
Option 1: Running Locally (Manual)
Clone the Repo:

Bash

git clone https://github.com/kodecloud95/AWS-ALB-EC2-Terraform-Stack.git
cd AWS-ALB-EC2-Terraform-Stack/terraform
Configure AWS: Run aws configure and enter your keys.

Initialize & Deploy:

Bash

terraform init
terraform plan
terraform apply -auto-approve
Option 2: Running via Jenkins (Automated)
Setup Credentials: Add your AWS keys to Jenkins with the ID AWS_CREDENTIAL.

Create Pipeline: * Create a "New Item" -> "Pipeline".

Under Pipeline Definition, select "Pipeline script from SCM".

Enter your GitHub URL: https://github.com/kodecloud95/AWS-ALB-EC2-Terraform-Stack.git.

Run Build: Click Build Now. Jenkins will automatically init, plan, and apply the infrastructure.

⚠️ Troubleshooting common errors
403 Access Denied: This is usually due to an AWS Service Control Policy (SCP). Add a lifecycle { ignore_changes = [...] } block to your S3 or ALB resource to bypass restricted metadata checks.

Profile Not Found: Ensure your provider.tf does not have a hardcoded profile = "lab-03" when running in Jenkins.
