
# Create public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
  depends_on = [aws_internet_gateway.igw]
}

# Associate Route Tables with Subnets
resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
  depends_on = [aws_internet_gateway.igw, aws_subnet.public_subnet]
}

# Create private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
  depends_on = [aws_nat_gateway.nat_gw]
}

resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
  depends_on = [aws_nat_gateway.nat_gw, aws_subnet.private_subnet]
}