# ---networking/networking.tf---


# create a vpc
resource "aws_vpc" "nath_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    nath = "vpc"
  }
}

# create an igw
resource "aws_internet_gateway" "nath_igw" {
  vpc_id = aws_vpc.nath_vpc.id

  tags = {
    nath = "igw"
  }
}

# create a public subnet
resource "aws_subnet" "nath_public_subnet" {
  vpc_id                  = aws_vpc.nath_vpc.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    nath = "public_subnet"
  }
}

# create a public subnet2
resource "aws_subnet" "nath_public_subnet2" {
  vpc_id                  = aws_vpc.nath_vpc.id
  cidr_block              = "192.168.4.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"

  tags = {
    nath = "public_subnet2"
  }
}

# create public route table
resource "aws_route_table" "pubic_route_table" {
  vpc_id = aws_vpc.nath_vpc.id

  tags = {
    nath = "rt"
  }
}


#create default route 
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.pubic_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.nath_igw.id

}

# create route table association for public subnert
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.nath_public_subnet.id
  route_table_id = aws_route_table.pubic_route_table.id
}

# create route table association for public subnert
resource "aws_route_table_association" "public_subnet_assoc2" {
  subnet_id      = aws_subnet.nath_public_subnet2.id
  route_table_id = aws_route_table.pubic_route_table.id
}

# create security group
resource "aws_security_group" "Webserver-sg" {
  name        = "Webserver"
  description = "sg for frontend webserver"
  vpc_id      = aws_vpc.nath_vpc.id

  ingress {
    description = "NGINX"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    nath = "webserver-sg"
  }
}
