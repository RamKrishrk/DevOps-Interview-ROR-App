resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.project_name}-bucket"

  tags = {
    Name = "${var.project_name}-s3"
  }

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

