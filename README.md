# AWS-Based Resilient and Scalable Web Application Deployment

A production-style cloud infrastructure project demonstrating high availability, scalability, and secure web application deployment using core AWS services.

---

## Project Overview

This project demonstrates the deployment of a resilient and scalable web application on Amazon Web Services (AWS). The infrastructure is built using a Multi-Availability Zone architecture with Auto Scaling, an Application Load Balancer, Amazon EFS, and Amazon Route 53 for high availability and fault tolerance.

The web application is hosted on EC2 instances running Apache HTTP Server, with shared storage provided by Amazon EFS. Auto Scaling automatically provisions additional EC2 instances under CPU load, while Route 53 provides custom domain access.

---

## AWS Services Used

- Amazon VPC
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- Amazon EC2
- Amazon Machine Image (AMI)
- Launch Template
- Auto Scaling Group
- Application Load Balancer
- Amazon EFS
- Amazon Route 53
- Apache HTTP Server

---

# Solution Architecture

<img width="3846" height="4425" alt="Final_Design_1" src="https://github.com/user-attachments/assets/a5b3d7d9-62b5-4f9c-abcf-5e58c67b948f" />


This diagram illustrates the complete application architecture including Route 53, Application Load Balancer, Auto Scaling Group, EC2 instances, Amazon EFS, and Multi-AZ deployment.

---

# Network Architecture


<img width="1280" height="918" alt="VPC Design" src="https://github.com/user-attachments/assets/b266a6ea-580f-46b8-96b0-8bc6dee4a666" />


This diagram illustrates the networking architecture including VPC, Internet Gateway, NAT Gateway, Public and Private Subnets, and Route Tables.

---

# Project Workflow

1. Internet users access the application through a custom domain configured in Amazon Route 53.

2. Route 53 forwards requests to the Application Load Balancer.

3. The Application Load Balancer distributes incoming traffic across EC2 instances running in private subnets.

4. EC2 instances are deployed using a Launch Template and managed by an Auto Scaling Group.

5. Website files are stored on Amazon EFS and mounted on every EC2 instance.

6. During high CPU utilization, Auto Scaling automatically launches additional EC2 instances.

7. All instances share the same website content through Amazon EFS.

---

# Infrastructure Setup

## Step 1 — VPC Configuration

- Created a VPC in ap-south-1
- Configured two Availability Zones
- Created:
  - Two Public Subnets
  - Two Private Subnets
- Attached an Internet Gateway
- Configured Public and Private Route Tables
- Created a NAT Gateway for outbound internet access

---

## Step 2 — Amazon EFS

- Created Amazon Elastic File System
- Mounted EFS using amazon-efs-utils
- Added persistent mount configuration in `/etc/fstab`
- Shared website files across all EC2 instances

---

## Step 3 — Web Server

- Installed Apache HTTP Server
- Hosted a custom HTML website
- Stored website files on Amazon EFS

---

## Step 4 — AMI & Launch Template

- Created an AMI from the configured EC2 instance
- Created a Launch Template using the AMI
- Added User Data for automated instance configuration

---

## Step 5 — Auto Scaling

Configured:

- Minimum Capacity: 2
- Maximum Capacity: 5
- Dynamic Scaling based on CPU utilization

Stress testing automatically launched additional EC2 instances.

---

## Step 6 — Application Load Balancer

Configured:

- Listener Port 80
- Listener Port 8080
- Target Groups
- Health Checks

Traffic is distributed across healthy EC2 instances.

---

## Step 7 — Route 53

- Purchased a custom domain
- Created a Hosted Zone
- Configured an Alias A Record pointing to the Application Load Balancer

The application became accessible through the custom domain.

---

# Security Configuration

### ALB Security Group

- HTTP (80)
- TCP (8080)

---

### EC2 Security Group

- Port 80 from ALB Security Group
- Port 8080 from authorized source

---

### EFS Security Group

- NFS (2049)
- Allowed only from EC2 Security Group

---

# Project Demonstration

## VPC

<img width="1985" height="1009" alt="vpc" src="https://github.com/user-attachments/assets/48e65547-a379-4b77-936f-d7f48714e238" />


---

## Public & Private Subnets

<img width="2232" height="309" alt="Subnets" src="https://github.com/user-attachments/assets/53ca94aa-8406-4f8e-bcdb-8667fa6f87c9" />


---

## Route Tables

<img width="2234" height="343" alt="RouteTables" src="https://github.com/user-attachments/assets/6701d993-fc93-4242-aa7f-56fe07deaf00" />


---

## Internet Gateway

<img width="2234" height="227" alt="igw" src="https://github.com/user-attachments/assets/52e610f5-7dc7-47d0-9309-8181c7591cfd" />


---

## NAT Gateway

<img width="2242" height="235" alt="nat" src="https://github.com/user-attachments/assets/b5f8bad9-292d-4a07-91b5-65f9d24bc366" />


---

## Amazon EFS

<img width="2429" height="405" alt="efs" src="https://github.com/user-attachments/assets/6445caf1-077b-465b-a305-6aa525af8a45" />


---

## EC2 Instance

<img width="2241" height="312" alt="instances" src="https://github.com/user-attachments/assets/188e3dec-0736-4e92-91a1-044066d251f2" />


---

## Launch Template

<img width="2228" height="185" alt="launch_template" src="https://github.com/user-attachments/assets/21da74e7-fb69-4914-85e3-0c6d7333bd27" />


---

## Auto Scaling Group

<img width="2231" height="835" alt="ASG" src="https://github.com/user-attachments/assets/17afce74-f0b8-4336-9dfa-f4c16bb74826" />


---

## Auto Scaling Activity

<img width="2559" height="1151" alt="image" src="https://github.com/user-attachments/assets/0e43bece-d6f4-478e-8c8c-2f97f65fc573" />


---

## Application Load Balancer

<img width="2239" height="1045" alt="ALB" src="https://github.com/user-attachments/assets/91194d24-6fed-4843-b070-2b1b74775740" />


---

## Target Groups

<img width="2228" height="318" alt="tg" src="https://github.com/user-attachments/assets/9ad5019e-ae03-4d60-b3a7-01f7c50a9817" />


---

## Route 53

<img width="2559" height="786" alt="route 53" src="https://github.com/user-attachments/assets/7459c6fb-083d-42d4-9ccf-22637256a31b" />


---

## Website

<img width="2557" height="1389" alt="image" src="https://github.com/user-attachments/assets/204c8930-ef04-41c3-a245-03c3efe9a694" />

<img width="2559" height="901" alt="image" src="https://github.com/user-attachments/assets/d7d93a12-665e-4595-bc71-e227dffe7969" />

<img width="2559" height="903" alt="image" src="https://github.com/user-attachments/assets/9303a833-a094-40d7-97e9-f1a9a442cc98" />


---


# Author

**Vandit Jaiswal**

Cloud & DevOps Enthusiast




