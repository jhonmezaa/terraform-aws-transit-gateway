################################################################################
# Local Values
################################################################################

locals {
  # Region prefix mapping
  region_prefix = {
    "us-east-1"      = "ause1"
    "us-east-2"      = "ause2"
    "us-west-1"      = "ausw1"
    "us-west-2"      = "ausw2"
    "eu-west-1"      = "euwe1"
    "eu-central-1"   = "euce1"
    "ap-southeast-1" = "apse1"
    "ap-northeast-1" = "apne1"
    "sa-east-1"      = "saea1"
  }

  # Get current region from data source
  current_region = data.aws_region.current.region

  # Get region prefix
  region_code = lookup(local.region_prefix, local.current_region, "unkn")

  # Resource names following nomenclature: {region}-{resource_type}-{account_name}-{project_name}
  tgw_name       = "${local.region_code}-tgw-${var.account_name}-${var.project_name}"
  tgw_rtb_name   = "${local.region_code}-tgwrtb-${var.account_name}-${var.project_name}"
  ram_share_name = "${local.region_code}-ramshare-${var.account_name}-${var.project_name}"

  # This local was used for default route table tags but is no longer needed
  # Kept for backwards compatibility if referenced elsewhere
}
