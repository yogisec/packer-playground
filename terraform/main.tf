provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "image-factory" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "Image-Factory-VPC"
    Class = "image-factory"
  }
}

resource "aws_internet_gateway" "image-factory-gw" {
  vpc_id = aws_vpc.image-factory.id

  tags = {
    Name = "Image-Factory-VPC-IGW",
    Class = "image-factory"
  }
}

resource "aws_internet_gateway_attachment" "image-facttory-gw-attach" {
  internet_gateway_id = aws_internet_gateway.image-factory-gw.id
  vpc_id              = aws_vpc.image-factory.id
}

resource "aws_subnet" "image-factory-subnet" {
  vpc_id     = aws_vpc.image-factory.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Image-Factory-Subnet",
    Class = "image-factory"
  }
}
#
# Routes and route table need more work
#
resource "aws_route_table" "image-factory-route" {
  vpc_id = aws_vpc.image-factory.id

  route {
    cidr_block = "10.0.0.0/24"
    gateway_id = aws_internet_gateway.image-factory-gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  }

  tags = {
    Name = "Image-Factory-Route",
    Class = "image-factory"
  }
}