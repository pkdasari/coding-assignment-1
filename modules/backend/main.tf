
# Create S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name

  # versioning {
  #   enabled = true
  # }

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(var.tags, { Name = "terraform-state", Environment = var.environment })
}

# Create DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.tags, { Name = "terraform-locks", Environment = var.environment })
}
