################################################################################
# Transit Gateway for VPN Integration Example
################################################################################

module "tgw" {
  source = "../../transit-gateway"

  account_name = var.account_name
  project_name = var.project_name
  tags_common  = var.tags_common

  # Configuration optimized for VPN connectivity
  description     = "Transit Gateway for Site-to-Site VPN connectivity"
  amazon_side_asn = var.amazon_side_asn

  # Enable VPN-specific features
  enable_dns_support      = true
  enable_vpn_ecmp_support = true  # Important for VPN load balancing

  # Route table configuration
  enable_default_route_table_association = true
  enable_default_route_table_propagation = true

  # Auto-accept shared attachments (useful for multi-account VPN)
  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments

  # Security group referencing for cross-VPC communication
  enable_sg_referencing_support = true

  # No cross-account sharing for this example
  share_tgw = false
}
