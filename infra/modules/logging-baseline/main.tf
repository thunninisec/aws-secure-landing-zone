data "aws_caller_identity" "current" {}

locals {
  # S3 bucket names must be globally unique
  log_bucket_name = "${var.project_name}-${var.environment}-logs-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket        = local.log_bucket_name
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_public_access_block" "log_bucket" {
  bucket                  = aws_s3_bucket.log_bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # simple + low-cost for a portfolio MVP
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_bucket_policy" {
  statement {
    sid     = "AWSCloudTrailAclCheck"
    effect  = "Allow"
    actions = ["s3:GetBucketAcl"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    resources = [aws_s3_bucket.log_bucket.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    resources = [
      "${aws_s3_bucket.log_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = data.aws_iam_policy_document.cloudtrail_bucket_policy.json
}

resource "aws_cloudtrail" "org_trail" {
  name                          = "${var.project_name}-${var.environment}-trail"
  s3_bucket_name                = aws_s3_bucket.log_bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}
