module "guardrails" {
  source = "./modules/guardrails"
}

module "logging" {
  source        = "./modules/logging-baseline"
  project_name  = var.project_name
  environment   = var.environment
  force_destroy = var.log_bucket_force_destroy
}

module "iam_baseline" {
  source = "./modules/iam-baseline"
}
