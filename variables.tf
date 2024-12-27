# AWS region 
variable "region" {
    default = "us-east-1"
}

# IP address for VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# Creating 2 subnets on VPC
variable "subnet_cidrs" {
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

# Type of EC2 instance to be created
variable "instance_type" {
  default = "t2.micro"
}

# variable db_password as string for RDS DB
variable "db_password" {
  description = "Password for RDS database"
  type = string
}
