
# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
  depends_on = [aws_vpc.main]
}

/*
# Attach Internet Gateway to VPC, if IGW created without VPC_ID
resource "aws_internet_gateway_attachment" "igw_attachment" {
  vpc_id = aws_vpc.main.id
  internet_gateway_id = aws_internet_gateway.igw.id]
}
*/

# Create NAT Gateway
resource "aws_eip" "nat_eip" {
    domain = "vpc"
    region = "us-east-1"
    tags = {
      Name = "${var.vpc_name}-nat-eip"
    }
    depends_on = [aws_vpc.main]
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = aws_subnet.public_subnet["public"].id
    allocation_id = aws_eip.nat_eip.id
  tags = {
    Name = "${var.vpc_name}-nat-gw"
  }
  depends_on = [aws_subnet.public_subnet["public"], aws_internet_gateway.igw]
}

