################################################################################
# Transit Gateway
################################################################################

resource "aws_ec2_transit_gateway" "this" {
  count = var.create_tgw ? 1 : 0

  description                        = var.description
  amazon_side_asn                    = var.amazon_side_asn
  default_route_table_association    = var.enable_default_route_table_association ? "enable" : "disable"
  default_route_table_propagation    = var.enable_default_route_table_propagation ? "enable" : "disable"
  auto_accept_shared_attachments     = var.enable_auto_accept_shared_attachments ? "enable" : "disable"
  vpn_ecmp_support                   = var.enable_vpn_ecmp_support ? "enable" : "disable"
  multicast_support                  = var.enable_multicast_support ? "enable" : "disable"
  dns_support                        = var.enable_dns_support ? "enable" : "disable"
  transit_gateway_cidr_blocks        = var.transit_gateway_cidr_blocks
  security_group_referencing_support = var.enable_sg_referencing_support ? "enable" : "disable"

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

  tags = merge(
    { Name = local.tgw_name },
    var.tags_common
  )
}
