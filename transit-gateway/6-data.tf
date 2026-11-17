################################################################################
# Data Sources
################################################################################

# Region used for naming: var.region when set, otherwise the provider region
data "aws_region" "current" {
  region = var.region
}
