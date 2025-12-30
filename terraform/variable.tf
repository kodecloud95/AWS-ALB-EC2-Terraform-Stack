variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "public_cidr_region" {
  description = "The CIDR block for the VPC"
  type = map (object ({
    cidr = string
    region = string
    tag-value = string
  }))
  default = {
    public = {cidr = "10.0.1.0/24", region = "us-east-1a", tag-value = "public"}
    lb1    = {cidr = "10.0.3.0/24", region = "us-east-1a", tag-value = "lb1"}
    lb2    = {cidr = "10.0.4.0/24", region = "us-east-1b", tag-value = "lb2"}
  }
}


variable "private_cidr_region" {
  description = "The CIDR block for the private Subnet"
  type = object ({
    cidr = string
    region = string
    tag-value = string
  })
  default = {
    cidr = "10.0.2.0/24"
    region = "us-east-1b"
    tag-value = "private"
  }
}


/*
Terraform AWS EC2 - ALB infrastructure

Terraform to deploy infrastructure
1. Create VPC enable Host DNS
2. One subnet for public and Two for Load balancer different location total three
3. Internet gateway attach to VPC
4. NAT gateway Attach to VPC
5. Public route table add route to internet gateway and associate IGW
6. Private route table add route to Nat Gateway and associate Public subnet
7. Public security group
8. Private security group
9. Two ECS public instance but no public IP, install Apache by default
10. Create target group with EC2
11. Create application load balancer and add target group
*/
