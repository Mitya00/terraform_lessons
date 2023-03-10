provider "aws" {
  region = "us-east-1"
}



locals {
    azs = ["us-east-1a","us-east-1b","us-east-1c",]
}

//VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-roza"
  }
}

//SUBNET
resource "aws_subnet" "mintemir" {
  count = 3
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = local.azs[count.index]

  tags = {
    Name = "mitya${count.index}"
  }
}

//INTERNET_GATEWAY
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "mitya-gw"
  }
}

//ROUTE_TABLE
resource "aws_route_table" "route" {
count = 3
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "mitya-route${count.index}"
  }
}

//route_table_association
resource "aws_route_table_association" "a" {
    count = 3
  subnet_id      = aws_subnet.mintemir.*.id[count.index]
  route_table_id = aws_route_table.route.*.id[count.index]
}