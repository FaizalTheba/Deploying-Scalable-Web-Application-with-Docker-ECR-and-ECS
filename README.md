## Launched EC2 Instance and Built Docker Image
- I utilized Terraform to provision AWS infrastructure, including VPC, public subnet, internet gateway, route table, security group, and an EC2 instance with Ubuntu.
- I embedded a shell script within the Terraform configuration to automate Docker installation and configuration during EC2 instance initialization.
- I created a Dockerfile and an index.html file, successfully constructing a Docker image for the project.
- Deployed the application within a Docker container, demonstrating expertise in AWS infrastructure management, Docker, and automated deployment.

## ECR Private Repository
- I created an ECR private repository for secure Docker image storage.
- Configured an IAM role for the EC2 instance to securely access the ECR, adhering to security best practices.
- I pushed the Docker image to the ECR private repository using ECR push commands.

## Application Load Balancer
- I configured an internet-facing Application Load Balancer spanning two availability zones, associated with a Target Group.

## ECS: Task Definition, Cluster, and Service
- I created a task definition with the Fargate launch type, incorporating the Docker image as a container.
- Further, I provisioned an ECS cluster with Fargate infrastructure to orchestrate tasks and services.
- As a file step, I deployed a service within the ECS cluster, linked the task definition, specified a desired task count of 2, and successfully launched it.
- I verified application accessibility via the Application Load Balancer..