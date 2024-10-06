# ECS-with-Terraform-Project
deploy a wordpress and mysql container on aws ecs using Terraform 

# Introduction
This project demonstrates how to use Terraform to set up AWS resources required for deploying a WordPress application that uses MySQL as its database. The services are orchestrated using AWS ECS (Elastic Container Service). Both containers (WordPress and MySQL) are managed in ECS tasks. The WordPress service is exposed to the internet through an Elastic Load Balancer (ELB), while the MySQL service remains private in a secure VPC.

Prerequisites

Before running the Terraform scripts, ensure you have the following:

AWS Account with IAM credentials configured in your environment.

Terraform (v1.0 or higher) installed. You can download it from here.

AWS CLI installed and configured with your credentials.

Permissions for creating the following AWS resources:
ECS cluster

VPC and subnets

Security Groups

IAM roles


# Deployment Instructions
Follow these steps to deploy the infrastructure:

# 1. Clone the Repository
Clone this repository to your local environment:

git clone <repository_url>

cd <project_directory>

# 2. Initialize Terraform
Before running any Terraform commands, initialize the working directory by downloading the necessary provider plugins:

terraform init

# 3. Preview the Deployment Plan
To see what changes Terraform will make, run the following command:


terraform plan
Review the output to ensure it matches your expectations.

# 4. Apply the Terraform Configuration
To apply the configuration and create the infrastructure, run:


terraform apply
Terraform will prompt you to confirm. Type yes to proceed. This will create the ECS cluster, VPC, subnets, security groups, and deploy the MySQL and WordPress containers.

# 5. Access the WordPress Application
Once the infrastructure is provisioned, the WordPress application should be accessible via the public DNS of the Elastic Load Balancer. This URL is output at the end of the Terraform process.
