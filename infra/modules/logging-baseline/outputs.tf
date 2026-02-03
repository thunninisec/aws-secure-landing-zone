output "log_bucket_name" {
  value = aws_s3_bucket.log_bucket.bucket
}

output "cloudtrail_arn" {
  value = aws_cloudtrail.org_trail.arn
}
