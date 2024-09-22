
# Terraform Deployment

This project provides Terraform configurations for deploying an Amazon EKS (Elastic Kubernetes Service) cluster, including associated resources such as VPC, security groups, and CI/CD pipelines using Jenkins. The setup emphasizes security best practices and modular code for reusability.

## Table of Contents

- [Requirements](#requirements)
- [File Structure](#file-structure)
- [Usage](#usage)
- [Environment Variables](#environment-variables)
- [Modules](#modules)
- [Managing Environments using Terraform Workspaces](#managing-environments-using-terraform-workspaces)
  - [1. Set Up Terraform Workspaces](#1-set-up-terraform-workspaces)
  - [2. Environment-Specific Variables](#2-environment-specific-variables)
  - [3. Running Terraform for Different Environments](#3-running-terraform-for-different-environments)
    - [3.1 Development Environment](#31-development-environment)
    - [3.2 Staging Environment](#32-staging-environment)
    - [3.3 Production Environment](#33-production-environment)
  - [4. Managing State with Workspaces](#4-managing-state-with-workspaces)
- [Helmcharts for webapp](#)
- [Jenkins](#jenkins-pipeline-setup)
- [Outputs](#outputs)
- [License](#license)

## Requirements

- Terraform >= 1.0
- AWS account with necessary permissions
- AWS CLI installed and configured
- Jenkins for CI/CD (optional)


## Usage

# Terraform Environment Management

This repository provides a structured approach to managing multiple environments (development, staging, and production) using Terraform workspaces. It includes modules for backend infrastructure, EKS, IAM, security groups, and VPC.


## Modules

- **backend**: Configurations for backend services.
- **eks**: Configuration for Amazon EKS (Elastic Kubernetes Service).
- **iam**: IAM roles and policies for managing permissions.
- **security-group**: Security group configurations for controlling inbound and outbound traffic.
- **vpc**: Virtual Private Cloud configurations.


## Clone the repository

```bash
git clone <repository-url>
cd <cloned repo directory>
terraform init
```

## Managing Environments using Terraform Workspaces

Terraform workspaces help isolate environments by maintaining separate state files for each workspace. By default, a `default` workspace exists, but you can create additional workspaces for different environments.

### 1. Set Up Terraform Workspaces

Create the necessary workspaces by running the following commands:

```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

You can switch between workspaces using:

```bash
terraform workspace select dev
```

### 2. Environment-Specific Variables
Use workspace-specific variable files (e.g., dev.tfvars, staging.tfvars, prod.tfvars) to configure different settings for each environment.


#### Environment Variables
You can define the following variables in your .tfvars files for each environment:

* aws_region: AWS region for the environment
* aws_access_key: AWS access key for the environment
* aws_secret_key: AWS secret key for the environment
* aws_account_id: AWS account ID for the environment
* cluster_name: EKS Cluster name
* min_capacity: Minimum capacity for EKS node group
* max_capacity: Maximum capacity for EKS node group
* instance_type: Instance type for the EKS nodes
* key_name: Name of the SSH key pair to access instances
* tags: Tags to apply to resources
* whitelisted_ips: 
* s3_bucket_name: Storing Terraform State on S3
* dynamodb_table_name: DynamoDB Table name for Locking terraform state
* vpc_cidr: VPC CIDR Range for Networking
* private_subnets_cidr: Private subnet cidr range for Networking
* public_subnets_cidr: Public subnet cidr range for Networking


### 3. Running Terraform for Different Environments

When you run Terraform, you’ll specify the workspace and corresponding .tfvars file for each environment.

For dev environment:

```bash
terraform workspace select dev
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

For staging environment:
```bash
terraform workspace select staging
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"
```

For prod environment:
```bash
terraform workspace select prod
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

This ensures that:

You use separate state files for each environment.
You deploy environment-specific resources without hardcoding any values.

## 4. Managing State with Workspaces
Terraform workspaces isolate the state file for each environment. When you switch to a workspace, Terraform automatically uses the state file corresponding to that workspace. This is particularly useful when you want to maintain isolated states for dev, staging, and prod environments.

State files are stored in .terraform/ folder under workspace-specific subdirectories.



## EKS AddOns
### aws-ebs-csi-driver
- Add the `aws-ebs-csi-driver` Helm repository.
```sh
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update
```

- Install the latest release of the driver.
```sh
helm upgrade --install aws-ebs-csi-driver \
    --namespace kube-system \
    aws-ebs-csi-driver/aws-ebs-csi-driver
```

- Once the driver has been deployed, verify the pods are running:
```sh
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
```

### aws-load-balancer-controller (AWS Load Balancer Controller)
- AWS Load Balancer controller Helm chart for Kubernetes
```sh
helm repo add eks https://aws.github.io/eks-charts
# If using IAM Roles for service account install as follows -  NOTE: you need to specify both of the chart values `serviceAccount.create=false` and `serviceAccount.name=aws-load-balancer-controller`
helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=my-cluster -n kube-system --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
# If not using IAM Roles for service account
helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=hub -n kube-system
```



## Jenkins Pipeline Setup

To establish a Jenkins pipeline that executes a Terraform script for infrastructure provisioning and triggers email notifications, we can break down the process into several steps:

### Prerequisites:

#### Jenkins setup with necessary plugins:
* Terraform Plugin
* Email Extension Plugin
* Terraform installed on the Jenkins node or Docker image.
* AWS credentials configured on Jenkins for accessing AWS (via credentials manager or environment variables).
* SMTP setup in Jenkins for sending email notifications.

#### Jenkins Pipeline Configuration

Create a Jenkinsfile to define the pipeline stages. The pipeline will:

* Checkout the code from a Git repository.
* Initialize Terraform.
* Plan and apply the infrastructure changes.
* Deploy Web app using helmcharts
* Send email notifications with the output details.


#### Explanation of Key Sections:

* Agent: agent any means the pipeline will run on any available Jenkins agent. You can specify a particular agent if needed.
* Environment Variables:
 - AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are fetched from Jenkins credentials manager.
 - EMAIL_RECIPIENTS defines the email address(es) that will receive the notifications.

* Stages:
 - Checkout: Clones the Terraform script repository.
 - Terraform Init: Initializes Terraform in the project directory.
 - Terraform Plan: Executes the terraform plan command, storing the output in a plan file (tfplan).
 - Terraform Apply: Applies the changes based on the generated plan, using -auto-approve to bypass confirmation prompts
 - Helm Deploy: Deployes Web applicaiton on to EKS
* Post Conditions:
  - Success: If the pipeline completes successfully, an email with the details (branch, build URL, job name) is sent to the configured recipient(s).
  - Failure: If the pipeline fails, an email is sent notifying the recipient(s) of the failure, along with relevant build information.

#### SMTP Configuration (Jenkins Email Setup)

* Jenkins Dashboard → Manage Jenkins → Configure System.
* Scroll down to E-mail Notification and configure the SMTP server settings.
* Test Configuration to ensure emails are working.

#### Jenkins Plugins:

* Terraform Plugin (optional, for managing Terraform versions or using Terraform steps directly in the pipeline).
* Email Extension Plugin: Sends customizable email notifications.

#### Running the Pipeline:

* Push the Jenkinsfile to the root of your Git repository.
* In Jenkins, create a new pipeline job and point it to your Git repository.
* Start the pipeline, and it will provision the infrastructure via Terraform and send email notifications based on the outcome.

This setup ensures a fully automated CI/CD pipeline for provisioning infrastructure, with real-time email notifications to keep stakeholders updated.