# Create public Subnets

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = true

  for_each = var.public_cidr_region
  cidr_block        = each.value.cidr
  availability_zone = each.value.region
  
  tags = {
    Name = "${var.vpc_name}-subnet-${each.value.tag-value}"
  }
  depends_on = [aws_vpc.main]
}

# Create private Subnets

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = false
  cidr_block        = var.private_cidr_region.cidr
  availability_zone = var.private_cidr_region.region
  tags = {
    Name = "${var.vpc_name}-subnet-${var.private_cidr_region.tag-value}"
  }
  depends_on = [aws_vpc.main]
}