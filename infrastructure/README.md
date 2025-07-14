#  DevOps Assignment – Ruby on Rails on AWS ECS 

This Infrastructure as Code (IaC) solution provisions a scalable and secure AWS environment to deploy a Ruby on Rails application using **Docker**, **Nginx**, **ECS (Fargate)**, **ALB**, **RDS (PostgreSQL)**, and **S3** — all managed via **Terraform**.

---

## Folder Structure

├── main.tf # Entry point for Terraform
├── provider.tf # AWS provider config
├── variables.tf # Variables declarations
├── terraform.tfvars # Values for variables (should not include secrets in VCS)
├── outputs.tf # Terraform output values
├── README.md # This documentation
├── modules/ # Reusable Terraform modules
│ ├── alb/ # Application Load Balancer
│ ├── ecr/ # Elastic Container Registry setup
│ ├── ecs/ # ECS service, task definition
│ ├── iam/ # IAM roles and policies
│ ├── rds/ # RDS PostgreSQL DB
│ ├── s3/ # S3 bucket
│ ├── security/ # Security groups and firewall rules
│ └── vpc/ # VPC, subnets, NAT gateway
├── terraform.tfstate* # Terraform state files (ignored in Git)


---

##  Prerequisites

-  [Terraform](https://developer.hashicorp.com/terraform/downloads) ≥ 1.3
-  AWS CLI configured (`aws configure`)
-  Docker installed
-  Forked and cloned: [`https://github.com/mallowtechdev/DevOps-Interview-ROR-App`](https://github.com/mallowtechdev/DevOps-Interview-ROR-App)

---

##  Docker Build & Push to ECR

> Make sure your IAM user has ECR permissions.

```bash
# Login to ECR
aws ecr get-login-password --region ap-south-1 \
  | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com

# Build image (run from project root where Dockerfile exists)
docker build -t ror-nginx-app:latest -f docker/nginx/Dockerfile .

# Tag and push to ECR
docker tag ror-nginx-app:latest <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/ror-nginx-app:latest
docker push <aws_account_id>.dkr.ecr.ap-south-1.amazonaws.com/ror-nginx-app:latest


cd infrastructure/

terraform init

terraform apply \
  -var="image_url=<your_ecr_image_url>" \
  -var="db_password=<secure_postgres_password>"

RDS_DB_NAME         = "postgres"
RDS_USERNAME        = "admin"
RDS_PASSWORD        = "<from tfvars or secrets manager>"
RDS_HOSTNAME        = "<fetched from RDS endpoint output>"
RDS_PORT            = "5432"
S3_BUCKET_NAME      = "<bucket-name>"
S3_REGION_NAME      = "ap-south-1"
LB_ENDPOINT         = "<alb-dns-name>"

# Access the Application

http://<alb-dns-name>

