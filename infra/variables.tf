variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used for naming"
  type        = string
  default     = "aws-secure-landing-zone"
}

variable "log_bucket_force_destroy" {
  description = "For labs/portfolio: allow terraform destroy to delete the log bucket contents"
  type        = bool
  default     = true
}
