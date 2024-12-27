# Required variables
# AWS region 
variable "region" {
  description = "AWS region"
  type        = string
}

# IP address for VPC
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

# Creating 2 subnets on VPC
variable "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to SSH"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

# Type of EC2 instance to be created
variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

# variable db_password as string for RDS DB
variable "db_password" {
  description = "Password for RDS database"
  type = string
  sensitive = true
}

