variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr2" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone" {
  description = "Availability zone for subnets"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "ssh_allowed_ip" {
  description = "Your IP address for SSH access (CIDR format)"
  type        = string
  default     = "0.0.0.0./0"  # Replace with your actual IP before apply
}

variable "key_pair_name" {
  description = "Existing AWS Key Pair name for EC2 instances"
  type        = string
  default     = "Mendy"  # Replace with your key pair name
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "app_port" {
  description = "Application port for backend (for App SG)"
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "Database port (for DB SG)"
  type        = number
  default     = 3306
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "password"
}