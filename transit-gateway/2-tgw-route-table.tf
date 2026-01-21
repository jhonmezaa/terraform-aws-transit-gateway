################################################################################
# Transit Gateway Route Table
################################################################################

resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.create_tgw && var.create_tgw_routes ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id

  tags = merge(
    { Name = local.tgw_rtb_name },
    var.tags_common
  )
}
