# display the ID of VPC created by aws_vpc.main resource
output "vpc_id" {
  value = aws_vpc.main.id
}

# display ID of EC2 instance created by aws_instance.web resource
output "web_instance_id" {
  value = aws_instance.web.id
}

# display the endpoint of the RDS instance created by the aws_db_instance.rds resource
output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}