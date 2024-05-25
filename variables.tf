
variable "region" {
  description = "Region for the subnetwork"
  type        = string
  validation {
    condition     = length(var.region) > 0
    error_message = "Region cannot be empty!"
  }

  validation {
    condition = contains([
      "us-east-1", "us-east-4", "us-west-1", "us-west-2", "us-west-3", "us-west-4", "us-central-1",
      "northamerica-northeast-1", "southamerica-east-1", "europe-west1", "europe-west2", "europe-west3",
      "europe-west4", "europe-west6", "asia-east-1", "asia-east-2", "asia-northeast-1", "asia-northeast-2",
      "asia-northeast-3", "asia-southeast-1", "asia-southeast-2", "australia-southeast-1"
    ], var.region)
    error_message = "Use an approved region!"
  }
}

variable "company" {
  description = "The company name to add to naming convention."
  type        = string
    validation {
    condition     = length(var.company) > 0
    error_message = "company must not be an empty string"
  }
}

variable "environment" {
  description = "work environment (matches /terraform/environments/{ENV} ) - e.g. sandbox | dev | uat |  prod"
  type        = string
    validation {
    condition     = length(var.environment) > 0
    error_message = "environment cannot be empty!"
  }
}

variable "log_retention" {
  description = "Log retention of access logs of state bucket."
  default     = 90
  type        = number
    validation {
    condition     = var.log_retention > 0
    error_message = "log_retention needs to be greater than 0!"
  }
}

variable "log_bucket_purpose" {
  description = "Name to identify the bucket's purpose"
  default     = "logging"
  type        = string
    validation {
    condition     = length(var.log_bucket_purpose) > 0
    error_message = "log_bucket_purpose cannot be empty!"
  }
}

variable "state_bucket_purpose" {
  description = "Name to identify the bucket's purpose"
  default     = "terraform-state"
  type        = string
    validation {
    condition     = length(var.state_bucket_purpose) > 0
    error_message = "state_bucket_purpose cannot be empty!"
  }
}

variable "log_bucket_versioning" {
  description = "A string that indicates the versioning status for the log bucket."
  default     = "Disabled"
  type        = string
  validation {
    condition     = contains(["Enabled", "Disabled", "Suspended"], var.log_bucket_versioning)
    error_message = "Valid values for versioning_status are Enabled, Disabled, or Suspended."
  }
}

variable "state_bucket_tags" {
  type        = map(string)
  default     = { Automation : "Terraform" }
  description = "Tags to associate with the bucket storing the Terraform state files"
}

variable "log_bucket_tags" {
  type        = map(string)
  default     = { Automation : "Terraform", Logs : "Terraform" }
  description = "Tags to associate with the bucket storing the Terraform state bucket logs"
}

variable "terraform_user" {
  description = "The username for the infrastructure provisioning user."
  type        = string
  default     = "terraform-user"
    validation {
    condition     = length(var.terraform_user) > 0
    error_message = "terraform_user name cannot be empty!"
  }
}

variable "terraform_user_permissions" {
  description = "The permissions for the infrastructure provisioning."
  type        = list(string)
  default     = ["s3:CreateBucket"]
}
