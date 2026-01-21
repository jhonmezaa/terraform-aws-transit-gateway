################################################################################
# Basic Transit Gateway Example
################################################################################

module "tgw" {
  source = "../../transit-gateway"

  account_name = var.account_name
  project_name = var.project_name
  tags_common  = var.tags_common

  # Basic configuration
  description     = "Basic Transit Gateway for testing"
  amazon_side_asn = "64512"

  # Enable essential features
  enable_dns_support      = true
  enable_vpn_ecmp_support = true

  # Default route table behavior
  enable_default_route_table_association = true
  enable_default_route_table_propagation = true

  # No cross-account sharing for basic example
  share_tgw = false
}
