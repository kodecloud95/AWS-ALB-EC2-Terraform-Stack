
# security groups
# security group for public subnet
resource "aws_security_group" "public_sg" {
  name        = "${var.vpc_name}-public-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-public-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_sg_https" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "public_sg_http" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "public_sg_mysql" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_ingress_rule" "public_sg_ssh" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "public_sg_icmp" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1  
}

# security group for private subnet
resource "aws_security_group" "private_sg" {
  name        = "${var.vpc_name}-private-sg"
  description = "Allow SSH, MySQL, HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_sg_mysql" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_ingress_rule" "private_sg_ssh" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "private_sg_icmp" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_egress_rule" "private_sg_icmp" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  ip_protocol       = -1  
}