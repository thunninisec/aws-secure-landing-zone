output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "cloudtrail_bucket_name" {
  value = module.logging.log_bucket_name
}

output "cloudtrail_arn" {
  value = module.logging.cloudtrail_arn
}
