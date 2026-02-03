resource "aws_s3_account_public_access_block" "account" {
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_ebs_encryption_by_default" "default" {
  enabled = true
}
