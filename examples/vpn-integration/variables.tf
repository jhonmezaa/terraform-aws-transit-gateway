variable "account_name" {
  description = "Account name for naming resources"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name for naming resources"
  type        = string
  default     = "vpn"
}

variable "amazon_side_asn" {
  description = "Amazon side BGP ASN"
  type        = string
  default     = "64512"
}

variable "enable_auto_accept_shared_attachments" {
  description = "Auto-accept attachment requests"
  type        = bool
  default     = false
}

variable "tags_common" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Example     = "vpn-integration"
    Purpose     = "Site-to-Site VPN connectivity"
  }
}
