################################################################################
# Local Values
################################################################################

locals {
  # Region prefix mapping
  region_prefix_map = {
    # US Regions
    "us-east-1" = "ause1"
    "us-east-2" = "ause2"
    "us-west-1" = "ausw1"
    "us-west-2" = "ausw2"
    # EU Regions
    "eu-west-1"    = "euwe1"
    "eu-west-2"    = "euwe2"
    "eu-west-3"    = "euwe3"
    "eu-central-1" = "euce1"
    "eu-central-2" = "euce2"
    "eu-north-1"   = "euno1"
    "eu-south-1"   = "euso1"
    "eu-south-2"   = "euso2"
    # AP Regions
    "ap-southeast-1" = "apse1"
    "ap-southeast-2" = "apse2"
    "ap-southeast-3" = "apse3"
    "ap-southeast-4" = "apse4"
    "ap-southeast-5" = "apse5"
    "ap-southeast-6" = "apse6"
    "ap-southeast-7" = "apse7"
    "ap-northeast-1" = "apne1"
    "ap-northeast-2" = "apne2"
    "ap-northeast-3" = "apne3"
    "ap-south-1"     = "apso1"
    "ap-south-2"     = "apso2"
    "ap-east-1"      = "apea1"
    "ap-east-2"      = "apea2"
    # SA Regions
    "sa-east-1" = "saea1"
    # CA Regions
    "ca-central-1" = "cace1"
    "ca-west-1"    = "cawe1"
    # MX Regions
    "mx-central-1" = "mxce1"
    # ME Regions
    "me-south-1"   = "meso1"
    "me-central-1" = "mece1"
    # AF Regions
    "af-south-1" = "afso1"
    # IL Regions
    "il-central-1" = "ilce1"
  }

  # Explicit region_prefix wins; otherwise map lookup ("unkn" kept as fallback
  # for regions not in the map, as in previous versions)
  region_prefix = var.region_prefix != null ? var.region_prefix : lookup(
    local.region_prefix_map,
    data.aws_region.current.region,
    "unkn"
  )

  # Name prefix - conditionally includes region prefix based on use_region_prefix variable
  name_prefix = var.use_region_prefix ? "${local.region_prefix}-" : ""

  # Resource names following nomenclature: {region}-{resource_type}-{account_name}-{project_name}
  tgw_name       = coalesce(var.name, "${local.name_prefix}tgw-${var.account_name}-${var.project_name}")
  tgw_rtb_name   = coalesce(var.tgw_route_table_name, "${local.name_prefix}tgwrtb-${var.account_name}-${var.project_name}")
  ram_share_name = coalesce(var.ram_name, "${local.name_prefix}ramshare-${var.account_name}-${var.project_name}")

  # Name and tags for the AWS-created default association route table
  tgw_default_rtb_name = "${local.name_prefix}tgwrtb-${var.account_name}-${var.project_name}-default"
  tgw_default_rtb_tags = merge(
    var.tags_common,
    var.tgw_default_route_table_tags,
    {
      Name      = local.tgw_default_rtb_name
      ManagedBy = "Terraform"
    }
  )
}
