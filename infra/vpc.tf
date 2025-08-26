resource "aws_vpc" "master_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "{var.user} - vpc"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.master_vpc.id

  tags = {
    Name = "{var.user} - igw"
  }

}

data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.master_vpc.id
  count                   = 2
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "{var.user} - public subnet"
  }

}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.master_vpc.id
  count             = 2
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]
}

resource "aws_nat_gateway" "ngw" {


  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.eip.id

  tags = {
    Name = "{var.user} - ngw"
  }

}

resource "aws_eip" "eip" {

}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.master_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.master_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id


}

