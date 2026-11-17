################################################################################
# General Variables
################################################################################

variable "account_name" {
  description = "Account name to be used in resource naming (e.g., 'shared', 'prod', 'dev')"
  type        = string

  validation {
    condition     = length(var.account_name) >= 1 && length(var.account_name) <= 32
    error_message = "account_name debe tener entre 1 y 32 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.account_name))
    error_message = "account_name solo puede contener letras minúsculas, números y guiones."
  }
}

variable "project_name" {
  description = "Project name to be used in resource naming (e.g., 'myapp', 'core')"
  type        = string

  validation {
    condition     = length(var.project_name) >= 1 && length(var.project_name) <= 32
    error_message = "project_name debe tener entre 1 y 32 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name solo puede contener letras minúsculas, números y guiones."
  }
}

variable "tags_common" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "region_prefix" {
  description = "Region prefix used in resource names. If null, it is derived from the current region using the internal region map."
  type        = string
  default     = null
}

variable "use_region_prefix" {
  description = "Whether to include the region prefix in resource names. When false, names omit the region prefix."
  type        = bool
  default     = true
}

variable "region" {
  description = "Region where the resources will be managed. Defaults to the region set in the provider configuration."
  type        = string
  default     = null
}

################################################################################
# Transit Gateway Variables
################################################################################

variable "name" {
  description = "Explicit Name tag for the Transit Gateway. If null, the generated name is used."
  type        = string
  default     = null
}

variable "tgw_tags" {
  description = "Additional tags for the Transit Gateway"
  type        = map(string)
  default     = {}
}

variable "create_tgw" {
  description = "Controls if Transit Gateway should be created"
  type        = bool
  default     = true
}

variable "description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = null
}

variable "amazon_side_asn" {
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session. The range is 64512 to 65534 for 16-bit ASNs and 4200000000 to 4294967294 for 32-bit ASNs"
  type        = string
  default     = null
}

variable "enable_default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = bool
  default     = true
}

variable "enable_default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = bool
  default     = true
}

variable "enable_auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted"
  type        = bool
  default     = false
}

variable "enable_vpn_ecmp_support" {
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled"
  type        = bool
  default     = true
}

variable "enable_multicast_support" {
  description = "Whether Multicast support is enabled"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Whether DNS support is enabled"
  type        = bool
  default     = true
}

variable "transit_gateway_cidr_blocks" {
  description = "One or more IPv4 or IPv6 CIDR blocks for the transit gateway. Must be a size /24 CIDR block or larger for IPv4, or /64 CIDR block or larger for IPv6"
  type        = list(string)
  default     = []
}

variable "timeouts" {
  description = "Create, update, and delete timeout configurations for the transit gateway"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

variable "enable_encryption_support" {
  description = "Whether encryption support (VPC encryption control) is enabled on the Transit Gateway. null (default) leaves the provider/AWS default untouched. Requires AWS provider >= 6.25."
  type        = bool
  default     = null
}

variable "tgw_default_route_table_tags" {
  description = "Tags for the default association route table created by AWS. When non-empty (and enable_default_route_table_association = true), the module tags it with tags_common + these tags + Name/ManagedBy using aws_ec2_tag."
  type        = map(string)
  default     = {}
}

variable "enable_sg_referencing_support" {
  description = "Whether security group referencing support is enabled"
  type        = bool
  default     = true
}

################################################################################
# Route Table Variables
################################################################################

variable "create_tgw_routes" {
  description = "Controls if Transit Gateway route table should be created"
  type        = bool
  default     = true
}

variable "tgw_route_table_name" {
  description = "Explicit Name tag for the Transit Gateway route table. If null, the generated name is used."
  type        = string
  default     = null
}

variable "tgw_route_table_tags" {
  description = "Additional tags for the Transit Gateway route table"
  type        = map(string)
  default     = {}
}

variable "transit_gateway_route_table_id" {
  description = "Not used by the module (it does not manage VPC attachments). Kept for backwards compatibility."
  type        = string
  default     = null
}

################################################################################
# Resource Access Manager Variables
################################################################################

variable "share_tgw" {
  description = "Whether to share the Transit Gateway with other accounts using Resource Access Manager"
  type        = bool
  default     = true
}

variable "ram_name" {
  description = "Explicit name for the RAM resource share. If empty, the generated name is used."
  type        = string
  default     = ""
}

variable "ram_allow_external_principals" {
  description = "Whether to allow external principals for the resource share"
  type        = bool
  default     = false
}

variable "ram_principals" {
  description = <<-EOT
    List of principals to share the Transit Gateway with. Supports:
    - AWS Account IDs: "123456789012"
    - Organization ARNs: "arn:aws:organizations::{ACCOUNT}:organization/o-xxxxx"
    - Organizational Unit ARNs: "arn:aws:organizations::{ACCOUNT}:ou/o-xxxxx/ou-xxxxx"
    You can mix different types in the same list.
  EOT
  type        = list(string)
  default     = []
}

variable "ram_resource_share_arn" {
  description = "ARN of the RAM resource share to accept. Required when create_tgw = false and share_tgw = true."
  type        = string
  default     = ""
}

variable "ram_tags" {
  description = "Additional tags for the RAM resource share"
  type        = map(string)
  default     = {}
}
