resource "aws_vpc" "main-vpc" {
  cidr_block         = var.vpc-cidr
  instance_tenancy   = "default"
  enable_dns_support = true

  tags = {
    Name = "${var.resource-name}-VPC"
  }
}

resource "aws_subnet" "pub-subnet1" {
  vpc_id                  = aws_vpc.main-vpc.id
  count                   = length(var.pub-subnet)
  cidr_block              = var.pub-subnet[count.index]["cidr_block"]
  availability_zone       = var.pub-subnet[count.index]["availability_zone"]
  map_public_ip_on_launch = true

  tags = {
    Name = var.pub-subnet[count.index]["name"]
  }
}


resource "aws_subnet" "pri-subnet1" {
  vpc_id     = aws_vpc.main-vpc.id
  count      = length(var.pri-subnet)
  cidr_block = var.pri-subnet[count.index]["cidr_block"]

  availability_zone       = var.pri-subnet[count.index]["availability_zone"]
  map_public_ip_on_launch = false

  tags = {
    Name = var.pri-subnet[count.index]["name"]
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.resource-name}-igw"
  }
}

resource "aws_eip" "nat-eip" {
  domain = "vpc"

  tags = {
    Name = "${var.resource-name}nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id     = aws_eip.nat-eip.id
  subnet_id         = aws_subnet.pub-subnet1[0].id
  connectivity_type = "public"
  tags = {
    Name = "${var.resource-name}nat-gateway"
  }
}

resource "aws_route_table" "pub-route-table" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.resource-name}-pub-route-table"
  }
}

resource "aws_route_table" "pri-route-table" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.resource-name}-pri-route-table"
  }
}

resource "aws_route_table_association" "pub-sn1-rt-assoc" {
  count          = length(var.pub-subnet)
  subnet_id      = aws_subnet.pub-subnet1[count.index].id
  route_table_id = aws_route_table.pub-route-table.id
}

resource "aws_route_table_association" "pub-sn2-rt-assoc" {
  count          = length(var.pri-subnet)
  subnet_id      = aws_subnet.pri-subnet1[count.index].id
  route_table_id = aws_route_table.pri-route-table.id
}
