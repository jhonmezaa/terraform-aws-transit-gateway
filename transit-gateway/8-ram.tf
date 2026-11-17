################################################################################
# Resource Access Manager (RAM)
################################################################################

resource "aws_ram_resource_share" "this" {
  count = var.create_tgw && var.share_tgw ? 1 : 0

  region = var.region

  name                      = local.ram_share_name
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(
    var.tags_common,
    var.ram_tags,
    {
      Name      = local.ram_share_name
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_ram_resource_association" "this" {
  count = var.create_tgw && var.share_tgw ? 1 : 0

  region = var.region

  resource_arn       = aws_ec2_transit_gateway.this[0].arn
  resource_share_arn = aws_ram_resource_share.this[0].id
}

resource "aws_ram_principal_association" "this" {
  count = var.create_tgw && var.share_tgw ? length(var.ram_principals) : 0

  region = var.region

  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.this[0].arn
}

resource "aws_ram_resource_share_accepter" "this" {
  count = !var.create_tgw && var.share_tgw ? 1 : 0

  region = var.region

  share_arn = var.ram_resource_share_arn

  lifecycle {
    precondition {
      condition     = var.ram_resource_share_arn != ""
      error_message = "ram_resource_share_arn es obligatorio cuando create_tgw = false y share_tgw = true."
    }
  }
}
