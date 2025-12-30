/*
resource "random_string" "random" {
  length  = 8
  special = false
  numeric = false
  upper   = false
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "s3-${var.vpc_name}-${random_string.random.result}"
  #remove this if need to use random region
  region = "us-east-1"
  tags = {
    Name        = "s3-${var.vpc_name}-${random_string.random.result}"
    Environment = "${var.vpc_name}"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
*/
