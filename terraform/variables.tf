# variable "vpc_id" {
#   description = "VPC ID"
#   type        = string
#   default     = "aws_vpc.master_vpc.id"

# }

variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "log_retention_in_days" {
  type = number

}

variable "vpc_cidr" {
  type = string

}

variable "user" {
  type = string

}

variable "public_subnet_cidr" {
  type = list(string)

}

variable "private_subnet_cidr" {
  type = list(string)

}

variable "cpu" {
  type = number

}

variable "memory" {
  type = number

}

variable "container_port" {
  type = number

}

variable "desired_count" {
  type = number

}

# variable "image" {
#   type    = string


# }

# variable "public_subnet_ids" {
#   type    = list(string)
#   default = ["aws_subnet.public_subnet[*].id"]

# }

# variable "private_subnet_ids" {
#   type    = list(string)
#   default = ["aws_subnet.private_subnet[*].id"]

# }
