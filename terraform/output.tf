output "vpc_networking" {
  description = "VPC Networking Details"
  value = {
    vpc_id                = aws_vpc.main.id
    public_subnet_ids     = [for s in aws_subnet.public_subnet : s.id]
    private_subnet_id     = aws_subnet.private_subnet.id
    internet_gateway_id   = aws_internet_gateway.igw.id
    nat_gateway_id        = aws_nat_gateway.nat_gw.id
    public_route_table_id = aws_route_table.public_rt.id
    private_route_table_id= aws_route_table.private_rt.id
    public_routes  = aws_route_table.public_rt.route
    private_routes = aws_route_table.private_rt.route
  }
}

output "security_groups" {
  description = "Route Table Details"
  value = {
    public_security_group_id  = aws_security_group.public_sg.id
    private_security_group_id = aws_security_group.private_sg.id
  }
}

output "load_balancer" {
  description = "Application Load Balancer Details"
  value = {
    alb_arn           = aws_lb.application_lb.arn
    alb_dns_name      = aws_lb.application_lb.dns_name
    alb_listener_arn  = aws_lb_listener.application_lb_listener.arn
    target_group_arn  = aws_lb_target_group.target.arn
  }
}

output "ec2_instances" {
  description = "EC2 Instances Details"
  value = {
    public_instance_01_id = aws_instance.public_instance_01.id
    public_instance_01_ip = aws_instance.public_instance_01.private_ip
    public_instance_02_id = aws_instance.public_instance_02.id
    public_instance_02_ip = aws_instance.public_instance_02.private_ip
  }
}

/*
output "s3_backend" {
  description = "S3 Backend Details"
  value = {
    s3_bucket_name = aws_s3_bucket.s3_bucket.id
    region         = aws_s3_bucket.s3_bucket.region
  }
}
*/