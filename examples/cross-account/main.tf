################################################################################
# Cross-Account Transit Gateway Example
################################################################################

module "tgw" {
  source = "../../transit-gateway"

  account_name = var.account_name
  project_name = var.project_name
  tags_common  = var.tags_common

  description     = "Shared Transit Gateway for multi-account networking"
  amazon_side_asn = "64512"

  # Enable all features
  enable_dns_support                     = true
  enable_vpn_ecmp_support                = true
  enable_auto_accept_shared_attachments  = true
  enable_multicast_support               = false
  enable_sg_referencing_support          = true

  # Route table configuration
  enable_default_route_table_association = true
  enable_default_route_table_propagation = true

  # Cross-account sharing via RAM
  share_tgw                     = true
  ram_allow_external_principals = false  # Only within organization
  ram_principals                = var.ram_principals
}
