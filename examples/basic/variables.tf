variable "account_name" {
  description = "Account name for naming resources"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for naming resources"
  type        = string
  default     = "test"
}

variable "tags_common" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "development"
    ManagedBy   = "Terraform"
    Example     = "basic-tgw"
  }
}
