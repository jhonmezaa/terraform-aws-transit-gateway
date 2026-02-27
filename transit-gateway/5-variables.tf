################################################################################
# General Variables
################################################################################

variable "account_name" {
  description = "Account name to be used in resource naming (e.g., 'shared', 'prod', 'dev')"
  type        = string
}

variable "project_name" {
  description = "Project name to be used in resource naming (e.g., 'myapp', 'core')"
  type        = string
}

variable "tags_common" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "use_region_prefix" {
  description = "Whether to include the region prefix in resource names. When false, names omit the region prefix."
  type        = bool
  default     = true
}

################################################################################
# Transit Gateway Variables
################################################################################

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

variable "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table to use when creating attachments"
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
  description = "Name of the resource share for the Transit Gateway"
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
  description = "ARN of the Resource Share that will be used to share the Transit Gateway"
  type        = string
  default     = ""
}
