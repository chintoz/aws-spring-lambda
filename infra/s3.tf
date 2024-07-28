resource "aws_s3_bucket" "spring_lambda_bucket" {
  bucket = "your-s3-bucket-name"

  tags = {
    Name        = "Spring Lambda Deployment Bucket"
    Environment = "Development"
  }
}