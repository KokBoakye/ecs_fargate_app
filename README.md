ECS Fargate App – Production-Ready Deployment (ALB, Auto Scaling, WAF, OIDC)


Mission: Dockerize an app and deploy it on ECS Fargate behind an Application Load Balancer, with Auto Scaling, AWS WAF, zero‑downtime deployments, and end‑to‑end IaC + CI/CD using Terraform and GitHub Actions (OIDC).


├── .github
│   └── workflows
│       ├── deploy_app.yaml          # CI/CD workflow to build & deploy app
│       └── deploy_dev_infra.yaml    # CI/CD workflow to provision infra
├── .gitignore
├── README.md                        # Documentation (this file)
├── application
│   ├── Dockerfile                   # Container build instructions
│   ├── app.py                       # Example application code
│   └── requirements.txt             # App dependencies
└── terraform
    ├── alb.tf                       # ALB + Target Groups + Listeners
    ├── backend.tf                   # Remote backend config
    ├── ecr.tf                       # ECR registry
    ├── ecs.tf                       # ECS Cluster + Service + Task Definitions
    ├── envs/
    │   └── dev.tfvars               # Environment-specific variables
    ├── logs.tf                      # CloudWatch logging
    ├── outputs.tf                   # Terraform outputs
    ├── provider.tf                  # AWS provider + OIDC auth
    ├── variables.tf                 # Input variables
    ├── vpc.tf                       # VPC, subnets, routing, NAT, IGW
    └── waf.tf                       # AWS WAF rules





🧱 Architecture (High Level)
Internet → AWS WAF (Web ACL) → Application Load Balancer (ALB)
                                    │
                              Target Group (HTTP/HTTPS)
                                    │
                              ECS Service (Fargate)
                              └─ ECS Tasks (awsvpc)
                                    │
                             Private Subnets in 2+ AZs
                                    │
                                  VPC (NAT, IGW)




High availability: ALB in 2+ AZs targets tasks in private subnets. NAT gateway(s) for egress.
Security: WAF attached to ALB; security groups restrict inbound/outbound.
Observability: CloudWatch Logs & Metrics, ALB access logs (S3), WAF logs.
Zero downtime: ECS rolling deployments with ALB health checks.


✅ Requirements & Prerequisites
AWS Account with admin (bootstrap) and OIDC deploy role for GitHub Actions.
Terraform, AWS CLI, Docker.
A DNS domain in Route 53 (optional but recommended for HTTPS).
GitHub Actions OIDC configured (no long‑lived credentials).



🔐 OIDC for GitHub Actions (No Static Keys)
Create an OIDC Identity Provider in AWS for GitHub.
Create an IAM Role with trust policy for the GitHub repo.
Attach least‑privilege policies (ECR push, ECS deploy, CloudWatch logs, etc.).
Reference the role in GitHub Actions workflow.


🌩️ Terraform Overview
Use modules for VPC, ECS, ALB, WAF, ECR, Observability.
Private/public subnets with NAT gateways for ECS tasks.
ECS Service runs in Fargate with awsvpc networking.
ALB routes traffic and performs health checks.
WAF attached to ALB with managed rules.
Auto Scaling based on ALB request count and CPU.


🚀 CI/CD Flow
deploy_dev_infra.yaml provisions infra with Terraform.
deploy_app.yaml builds app Docker image → pushes to ECR → updates ECS service.



🔎 Logging & Monitoring
CloudWatch Logs: ECS task logs.
ALB Access Logs: Stored in S3.
WAF Logs: CloudWatch or S3.
Metrics & Alarms: ECS CPU/Memory, ALB 5XX, WAF blocked requests.



🔑 Secrets & Config
Store in AWS Secrets Manager or SSM Parameter Store.
ECS task roles grant access.
Pass securely into containers as environment variables.


🧠 Service Discovery & Inter‑Service Communication
Public ALB for external traffic.
Cloud Map or internal load balancers for service-to-service.
ECS tasks in private subnets only.


🛡️ Security Posture
Security groups: ALB open to 80/443; ECS allows only ALB traffic.
WAF with managed rule sets.
Least privilege IAM roles.



♻️ Auto Scaling Strategy
Target tracking: ALB request count per target and CPU utilization.
Cooldowns to avoid thrash.
Min 2 tasks, max as budget allows.
Optional scheduled scaling.



🔄 Zero‑Downtime Deployments
ECS rolling updates with circuit breaker and rollback.
Health checks ensure traffic only to healthy containers.
Immutable image tags for deployments.


❓ Challenge Questions – Answers
1) How will you structure your VPC and subnets for ECS Fargate?
/16 VPC across 2 AZs.
Public subnets for ALB + NAT gateways.
Private subnets for ECS tasks.

2) What health check strategies will you implement for your ALB?
ALB health checks on /health endpoint.
Container health checks for ECS tasks.
App returns lightweight response to reduce false negatives.

3) How will you configure auto scaling policies for optimal performance and cost?
TargetTracking scaling on ALBRequestCountPerTarget and CPU utilization.
Cooldowns to prevent rapid scale in/out.
Minimum 2 tasks, max scaled as per budget.

4) What WAF rules will protect your application from attacks?
AWS Managed Rule Sets: Common, KnownBadInputs, SQLi.
Rate limiting rule to block abuse.
Optional IP reputation and geo restrictions.

5) How will you handle service discovery and inter-service communication?
Use Cloud Map or internal load balancers.
Keep ECS tasks in private subnets.
Restrict communication via security groups.

6) What logging and monitoring will you implement for your containers?
CloudWatch Logs for containers.
ALB and WAF logs stored in S3 or CloudWatch.
Metrics and alarms for ECS, ALB, WAF.

7) How will you manage application secrets and environment variables?
Store in Secrets Manager or Parameter Store.
ECS task definitions reference secrets.
Secure access granted through IAM roles.
