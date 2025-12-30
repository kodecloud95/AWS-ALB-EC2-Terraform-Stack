/*
This project builds a High-Availability Web Architecture on AWS using Terraform. 
It follows the "Standard Three-Tier" security model by placing web servers in 
private isolation while using a Load Balancer to handle public traffic.
*/

# Create VPC

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  region = "us-east-1"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

resource "aws_instance" "public_instance_01" {
  ami           = "ami-0ecb62995f68bb549"
  region        = "us-east-1"
  associate_public_ip_address = true
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet["public"].id
  security_groups = [aws_security_group.public_sg.id]
    user_data = <<-EOF
                #!/bin/bash
                # 1. Set password for the default 'ubuntu' user
                echo "ubuntu:ubuntu" | chpasswd

                # 2. Allow password login in SSH config
                sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              
                # 3. Restart SSH to apply changes
                systemctl restart ssh
                sudo apt-get update -y
                sudo apt-get install -y apache2
                systemctl start apache2
                systemctl enable apache2
                host=$(hostname)
                cat <<EOT > /var/www/html/index.html
                ${file("${path.module}/index.html")}
                server name: $host
                EOT
                EOF
    tags = {
      Name = "${var.vpc_name}-public-instance-01"
    }
    depends_on = [aws_nat_gateway.nat_gw]
}

resource "aws_instance" "public_instance_02" {
  ami           = "ami-0ecb62995f68bb549"
  region        = "us-east-1"
  associate_public_ip_address = false
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet["public"].id
  security_groups = [aws_security_group.public_sg.id]
    user_data = <<-EOF
                #!/bin/bash
                # 1. Set password for the default 'ubuntu' user
                echo "ubuntu:ubuntu" | chpasswd

                # 2. Allow password login in SSH config
                sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              
                # 3. Restart SSH to apply changes
                systemctl restart ssh
                sudo apt-get update -y
                sudo apt-get install -y apache2
                systemctl start apache2
                systemctl enable apache2
                host=$(hostname)
                cat <<EOT > /var/www/html/index.html
                ${file("${path.module}/index.html")}
                server name: $host
                EOT
                EOF
    tags = {
      Name = "${var.vpc_name}-public-instance-01"
    }
    depends_on = [aws_nat_gateway.nat_gw]
}

# Target Group for ALB
resource "aws_lb_target_group" "target" {
  name     = "${var.vpc_name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  depends_on = [aws_nat_gateway.nat_gw]
}

# Target Group Attachment
resource "aws_lb_target_group_attachment" "tg_attachment_1" {
  target_group_arn = aws_lb_target_group.target.arn
  target_id        = aws_instance.public_instance_01.id
  port             = 80
  depends_on = [aws_nat_gateway.nat_gw]
} 

resource "aws_lb_target_group_attachment" "tg_attachment_2" {
  target_group_arn = aws_lb_target_group.target.arn
  target_id        = aws_instance.public_instance_02.id
  port             = 80
  depends_on = [aws_nat_gateway.nat_gw]
}

# Application Load Balancer
resource "aws_lb" "application_lb" {
  name               = "${var.vpc_name}-application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = [aws_subnet.public_subnet["lb1"].id, aws_subnet.public_subnet["lb2"].id]
  enable_deletion_protection = false
  depends_on = [aws_nat_gateway.nat_gw]

  tags = {
    Name = "${var.vpc_name}-application-lb"
  }
}

resource "aws_lb_listener" "application_lb_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
  depends_on = [aws_nat_gateway.nat_gw]
}