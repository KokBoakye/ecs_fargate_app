

app_name = "myflask"

environment = "dev"

log_retention_in_days = 30


vpc_cidr = "10.0.0.0/16"


user = "kwabena"


public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]


private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]

cpu = 256


memory = 512

container_port = 8080

desired_count = 2



