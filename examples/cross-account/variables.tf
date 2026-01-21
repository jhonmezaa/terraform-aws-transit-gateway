variable "account_name" {
  description = "Account name for naming resources"
  type        = string
  default     = "shared"
}

variable "project_name" {
  description = "Project name for naming resources"
  type        = string
  default     = "network"
}

variable "ram_principals" {
  description = "List of principals to share Transit Gateway with"
  type        = list(string)
  default     = []
  # Example:
  # [
  #   "123456789012",  # Prod account
  #   "210987654321",  # Dev account
  #   "arn:aws:organizations::123456789012:organization/o-xxxxx"  # Entire org
  # ]
}

variable "tags_common" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "shared"
    ManagedBy   = "Terraform"
    Example     = "cross-account"
    Purpose     = "Multi-account networking hub"
  }
}
