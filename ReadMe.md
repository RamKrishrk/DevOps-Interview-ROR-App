#  DevOps Assignment: Deploy Dockerized Ruby on Rails App with Nginx in AWS using IaC

##  Introduction

This assignment showcases the deployment of a Dockerized Ruby on Rails application with Nginx on AWS. It uses Terraform for Infrastructure as Code to provision ECS (Fargate), RDS (PostgreSQL), S3, and an Application Load Balancer.

---

##  Project Structure

```
.
├── app/                        # Ruby on Rails application code
├── bin/                        # Rails binary scripts
├── config/                     # Rails configuration files
├── db/                         # Database migrations and schema
├── docker/
│   ├── app/                    # Rails Dockerfile and entrypoint
│   └── nginx/                  # Nginx config and Dockerfile
├── docker-compose.yml          # Optional: local multi-container setup
├── Gemfile / Gemfile.lock      # Ruby gem dependencies
├── infrastructure/
│   ├── main.tf, variables.tf   # Terraform core configs
│   ├── terraform.tfvars        # Variable values
│   ├── modules/                # Reusable Terraform modules (vpc, ecs, alb, etc.)
│   ├── README.md               # IaC setup guide
│   ├── terraform.tfstate*      # Terraform state files
│   └── architecture-diagram.png (expected)
├── rails_app.env               # ENV file for Rails container
├── ReadMe.md                   # Project documentation (this file)
└── scripts/                    # Utility scripts (e.g., check_s3_connection.sh)
```

---

##  Setup Instructions

### 1.Build Docker Image

```bash
cd docker/app
docker build -t rails_app .
```

### 2. Push to AWS ECR

- Authenticate Docker to ECR:
  ```bash
  aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account>.dkr.ecr.<region>.amazonaws.com
  ```

- Tag and push:
  ```bash
  docker tag rails_app <ecr_repo_url>:latest
  docker push <ecr_repo_url>:latest
  ```

### 3. Provision Infrastructure with Terraform

```bash
cd infrastructure
terraform init
terraform plan
terraform apply
```

This will create:
- VPC, subnets, security groups
- ECS Fargate cluster and service
- RDS PostgreSQL instance
- S3 bucket
- Application Load Balancer
- IAM roles for ECS and S3 access

---

##  Required Environment Variables

### Rails Container (`rails_app.env`)

```env
RDS_DB_NAME=rails
RDS_USERNAME=postgres
RDS_PASSWORD=admin123
RDS_HOSTNAME=postgres
RDS_PORT=5432

S3_BUCKET_NAME=my-local-test-bucket
S3_REGION_NAME=ap-south-1
LB_ENDPOINT=localhost```

---

##  Prerequisites

- AWS CLI configured with IAM access
- Docker & Docker Compose
- Terraform installed
- Git

---

##  Verification

- Access the app via the Load Balancer DNS.
- Test file upload to S3 (via app functionality).
- Ensure ECS tasks are running and healthy.

---

##  Cleanup

```bash
cd infrastructure
terraform destroy
```

---


