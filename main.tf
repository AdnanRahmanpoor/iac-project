provider "aws" {
  region = var.region
}

# VPC
# Creating VPC with main-vpc as name and cidr_block
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main-vpc"
  }
}

# subnets
# creating subnets and using count to create multiple ones
resource "aws_subnet" "subnets" {
  count = length(var.subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidrs[count.index]
  map_public_ip_on_launch = true
}

# Internet Gateway
# Attaching internet gateway to a VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Route Table
# Creating route table for VPC and adding a route for all internet-bound traffic (0.0.0.0/0)
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the route table with all subnets
resource "aws_route_table_association" "rta" {
  count = length(var.subnet_cidrs)
  subnet_id = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.main.id
}

# Security Groups
# Allow inbound traffic from port 80 and 22 for web_sg (web servers) 
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "web-sg"
  }
}

# Allow inbound traffic from port 3306 for db_sg (database) only from web security group
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [aws_security_group.web_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

# EC2 Instance
# Launching EC2 instance using Amazon Linux 2 AMI and placing it in first subnet and associate it with web security group
resource "aws_instance" "web" {
    ami = "ami-01816d07b1128cd2d" # Amazon Linux AMI
    instance_type = var.instance_type
    subnet_id = aws_subnet.subnets[0].id # first subnet
    security_groups = [aws_security_group.web_sg.name] # web security

    tags = {
      Name = "web-instance"
    }
}

# RDS
# Setup MYSQL RDS instance associate it with db security group and database password (db_password) variable 
resource "aws_db_instance" "rds" {
    allocated_storage = 20
    engine = "mysql"  
    engine_version = "8.0"
    instance_class = "db.t2.micro"
    username = "admin"
    password = var.db_password
    publicly_accessible = true
    vpc_security_group_ids = [aws_security_group.db_sg.id]
    skip_final_snapshot = true

    tags = {
      Name = "mydb"
    }
}
