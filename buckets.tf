resource "aws_s3_bucket" "api_responses_bucket" {
  bucket = "${var.product}-${var.environment}-responses-raw"

  tags = {
    "product_name" = var.product
    "resource" = "${var.product}-api-responses-bucket"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.api_responses_bucket.id
  acl    = "private"
}