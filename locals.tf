
locals {
  region              = var.region
  account_environment = "${var.company}-${var.environment}"
  terraform_user      = "${var.environment}-${var.terraform_user}"
  state_bucket        = "${var.company}-${var.environment}-${var.state_bucket_purpose}-s3"
  logging_bucket      = "${var.company}-${var.environment}-${var.log_bucket_purpose}-s3"
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Environment = local.account_environment
    Project     = "${var.company}-Infrastructure"
  }
}
