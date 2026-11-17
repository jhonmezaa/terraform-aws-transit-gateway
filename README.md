# AWS Transit Gateway Terraform Module

Terraform module to create and manage AWS Transit Gateway resources with standardized naming conventions and Resource Access Manager (RAM) sharing capabilities.

## Features

- ✅ **AWS Transit Gateway** creation with customizable configurations
- ✅ **Transit Gateway Route Table** management
- ✅ **Resource Access Manager (RAM)** sharing support for multi-account architectures
- ✅ **Automatic naming convention** following `{region}-{resource_type}-{account_name}-{project_name}` format
- ✅ **Auto-detection of AWS region** from provider configuration
- ✅ **Centralized tagging** with `tags_common` variable
- ✅ **Support for multiple sharing scenarios**: internal accounts, external accounts, AWS Organizations, and OUs

## Naming Convention

This module automatically generates resource names following a standardized format:

```
{region}-{resource_type}-{account_name}-{project_name}
```

### Components

1. **region**: 5-character AWS region code (auto-detected from provider)
2. **resource_type**: Abbreviated resource type
3. **account_name**: Account name (e.g., shared, prod, dev)
4. **project_name**: Project name (e.g., myapp, core)

### Region Codes

The prefix is resolved from the provider region (or `var.region`) using the internal `region_prefix_map` in `transit-gateway/7-locals.tf`. Set `region_prefix` to override it, or `use_region_prefix = false` to omit it. Regions not present in the map use `unkn`.

| AWS Region | Code | AWS Region | Code |
| --- | --- | --- | --- |
| us-east-1 | ause1 | ap-southeast-1 | apse1 |
| us-east-2 | ause2 | ap-southeast-2 | apse2 |
| us-west-1 | ausw1 | ap-southeast-3 | apse3 |
| us-west-2 | ausw2 | ap-southeast-4 | apse4 |
| eu-west-1 | euwe1 | ap-southeast-5 | apse5 |
| eu-west-2 | euwe2 | ap-southeast-6 | apse6 |
| eu-west-3 | euwe3 | ap-southeast-7 | apse7 |
| eu-central-1 | euce1 | ap-northeast-1 | apne1 |
| eu-central-2 | euce2 | ap-northeast-2 | apne2 |
| eu-north-1 | euno1 | ap-northeast-3 | apne3 |
| eu-south-1 | euso1 | ap-south-1 | apso1 |
| eu-south-2 | euso2 | ap-south-2 | apso2 |
| sa-east-1 | saea1 | ap-east-1 | apea1 |
| ca-central-1 | cace1 | ap-east-2 | apea2 |
| ca-west-1 | cawe1 | me-south-1 | meso1 |
| mx-central-1 | mxce1 | me-central-1 | mece1 |
| af-south-1 | afso1 | il-central-1 | ilce1 |

### Resource Types

| Resource                    | Code     |
| --------------------------- | -------- |
| Transit Gateway             | tgw      |
| Transit Gateway Route Table | tgwrtb   |
| RAM Resource Share          | ramshare |
| Default association route table (tags only, opt-in) | tgwrtb-…-default |

### Example Names

For a deployment in `us-east-2` (Ohio) with `account_name = "shared"` and `project_name = "myapp"`:

- Transit Gateway: `ause2-tgw-shared-myapp`
- TGW Route Table: `ause2-tgwrtb-shared-myapp`
- RAM Share: `ause2-ramshare-shared-myapp`

## Requirements

| Name      | Version  |
| --------- | -------- |
| terraform | >= 1.3   |
| aws       | >= 6.25  |

## Usage

### Basic Example with Terraform

```hcl
provider "aws" {
  region = "us-east-2"
}

module "transit_gateway" {
  source = "github.com/jhonmezaa/terraform-aws-transit-gateway//transit-gateway?ref=v1.2.0"

  # Naming (region is auto-detected from provider)
  account_name = "shared"
  project_name = "myapp"

  # Description
  description = "Transit Gateway for network connectivity"

  # Transit Gateway Configuration
  amazon_side_asn                        = 64512
  enable_default_route_table_association = true
  enable_default_route_table_propagation = true
  enable_auto_accept_shared_attachments  = true
  enable_vpn_ecmp_support                = true
  enable_dns_support                     = true
  enable_multicast_support               = false
  enable_sg_referencing_support          = true

  # Common Tags
  tags_common = {
    Environment = "production"
    Project     = "Infrastructure"
    Owner       = "Cloud-Team"
    CostCenter  = "IT-Infrastructure"
  }
}
```

### Example with RAM Sharing

```hcl
module "transit_gateway" {
  source = "github.com/jhonmezaa/terraform-aws-transit-gateway//transit-gateway?ref=v1.2.0"

  account_name = "shared"
  project_name = "myapp"
  description  = "Shared Transit Gateway for multi-account architecture"

  # RAM Configuration
  share_tgw                     = true
  ram_allow_external_principals = false

  # Share with specific accounts and organization
  ram_principals = [
    "123456789012",  # Production account
    "234567890123",  # Development account
    "arn:aws:organizations::111111111111:organization/o-xxxxxxxxxx"  # Entire organization
  ]

  tags_common = {
    Environment = "shared"
    Project     = "Infrastructure"
  }
}
```

### Example with Encryption Support and Default Route Table Tags

```hcl
module "transit_gateway" {
  source = "github.com/jhonmezaa/terraform-aws-transit-gateway//transit-gateway?ref=v1.2.0"

  account_name = "shared"
  project_name = "myapp"

  # Enable Transit Gateway encryption support (AWS provider >= 6.25)
  enable_encryption_support = true

  # Tag the default association route table created by AWS
  # (Name = "{prefix}-tgwrtb-shared-myapp-default")
  tgw_default_route_table_tags = {
    Purpose = "default-association"
  }
}
```

## Inputs

### Required Inputs

| Name         | Description                                                                | Type     |
| ------------ | -------------------------------------------------------------------------- | -------- |
| account_name | Account name used in resource naming (1-32 chars, `^[a-z0-9-]+$`)          | `string` |
| project_name | Project name used in resource naming (1-32 chars, `^[a-z0-9-]+$`)          | `string` |

### Optional Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| tags_common | Common tags applied to all resources | `map(string)` | `{}` |
| region_prefix | Region prefix used in names. If `null`, it is derived from the region using the internal map | `string` | `null` |
| use_region_prefix | Whether to include the region prefix in resource names | `bool` | `true` |
| region | Region where the resources are managed. Defaults to the provider region | `string` | `null` |
| name | Explicit Name tag for the Transit Gateway (overrides the generated name) | `string` | `null` |
| tgw_tags | Additional tags for the Transit Gateway | `map(string)` | `{}` |
| create_tgw | Controls if the Transit Gateway should be created | `bool` | `true` |
| description | Description of the Transit Gateway | `string` | `null` |
| amazon_side_asn | Private ASN for the Amazon side of a BGP session | `string` | `null` |
| enable_default_route_table_association | Whether attachments are automatically associated with the default association route table | `bool` | `true` |
| enable_default_route_table_propagation | Whether attachments automatically propagate routes to the default propagation route table | `bool` | `true` |
| enable_auto_accept_shared_attachments | Whether attachment requests are automatically accepted | `bool` | `false` |
| enable_vpn_ecmp_support | Whether VPN ECMP support is enabled | `bool` | `true` |
| enable_multicast_support | Whether multicast support is enabled | `bool` | `false` |
| enable_dns_support | Whether DNS support is enabled | `bool` | `true` |
| enable_encryption_support | Whether encryption support is enabled. `null` leaves the AWS default untouched | `bool` | `null` |
| enable_sg_referencing_support | Whether security group referencing support is enabled | `bool` | `true` |
| transit_gateway_cidr_blocks | IPv4 (/24 or larger) or IPv6 (/64 or larger) CIDR blocks for the Transit Gateway | `list(string)` | `[]` |
| timeouts | Create, update and delete timeouts for the Transit Gateway | `object({create, update, delete})` | `null` |
| tgw_default_route_table_tags | Tags for the AWS-created default association route table. When non-empty, the module tags it (Name `{prefix}-tgwrtb-{account}-{project}-default`) | `map(string)` | `{}` |
| create_tgw_routes | Controls if the custom Transit Gateway route table should be created | `bool` | `true` |
| tgw_route_table_name | Explicit Name tag for the custom route table (overrides the generated name) | `string` | `null` |
| tgw_route_table_tags | Additional tags for the custom route table | `map(string)` | `{}` |
| transit_gateway_route_table_id | Not used by the module (it does not manage VPC attachments). Kept for backwards compatibility | `string` | `null` |
| share_tgw | Whether to share the Transit Gateway through RAM | `bool` | `true` |
| ram_name | Explicit name for the RAM resource share. If empty, the generated name is used | `string` | `""` |
| ram_allow_external_principals | Whether principals outside your organization can be associated | `bool` | `false` |
| ram_principals | Principals to share with (account IDs, Organization ARNs, OU ARNs) | `list(string)` | `[]` |
| ram_resource_share_arn | ARN of the RAM share to accept. Required when `create_tgw = false` and `share_tgw = true` | `string` | `""` |
| ram_tags | Additional tags for the RAM resource share | `map(string)` | `{}` |

## Outputs

| Name | Description |
| --- | --- |
| ec2_transit_gateway_arn | EC2 Transit Gateway ARN |
| ec2_transit_gateway_id | EC2 Transit Gateway ID |
| ec2_transit_gateway_owner_id | ID of the AWS account that owns the Transit Gateway |
| ec2_transit_gateway_association_default_route_table_id | ID of the default association route table |
| ec2_transit_gateway_propagation_default_route_table_id | ID of the default propagation route table |
| ec2_transit_gateway_route_table_id | Custom Transit Gateway route table ID |
| ec2_transit_gateway_route_table_default_association_route_table | Whether the custom route table is the default association route table |
| ec2_transit_gateway_route_table_default_propagation_route_table | Whether the custom route table is the default propagation route table |
| ec2_transit_gateway_default_route_table_tags | Tags applied by the module to the default association route table |
| ram_resource_share_id | ARN of the RAM resource share |
| ram_principal_association_id | ID of the first RAM principal association (share ARN and principal, comma separated) |

All outputs return `null` when the corresponding resource is not created.

## Resource Access Manager (RAM) Sharing

This module supports sharing the Transit Gateway with other AWS accounts using AWS Resource Access Manager. RAM sharing requires:

1. **AWS Organizations enabled** in your account
2. **RAM sharing enabled** in Organizations settings
3. **Proper IAM permissions** to create RAM shares

### RAM Principal Types

You can share with:

- **Internal AWS Account IDs**: `"123456789012"`
- **External AWS Account IDs**: `"987654321098"` (requires `ram_allow_external_principals = true`)
- **Organization ARN**: `"arn:aws:organizations::{ACCOUNT}:organization/o-xxxxx"`
- **Organizational Unit ARN**: `"arn:aws:organizations::{ACCOUNT}:ou/o-xxxxx/ou-xxxxx"`

### Example Configurations

#### Share with Specific Accounts

```hcl
module "transit_gateway" {
  source = "github.com/jhonmezaa/terraform-aws-transit-gateway//transit-gateway?ref=v1.2.0"

  account_name = "shared"
  project_name = "myapp"

  share_tgw      = true
  ram_principals = [
    "123456789012",  # Account 1
    "234567890123",  # Account 2
  ]

  tags_common = {
    Environment = "shared"
  }
}
```

#### Share with Entire Organization

```hcl
module "transit_gateway" {
  source = "github.com/jhonmezaa/terraform-aws-transit-gateway//transit-gateway?ref=v1.2.0"

  account_name = "shared"
  project_name = "myapp"

  share_tgw      = true
  ram_principals = [
    "arn:aws:organizations::111111111111:organization/o-xxxxxxxxxx"
  ]

  tags_common = {
    Environment = "shared"
  }
}
```

#### Share with Organizational Unit

```hcl
module "transit_gateway" {
  source = "github.com/jhonmezaa/terraform-aws-transit-gateway//transit-gateway?ref=v1.2.0"

  account_name = "shared"
  project_name = "myapp"

  share_tgw      = true
  ram_principals = [
    "arn:aws:organizations::111111111111:ou/o-xxxxxxxxxx/ou-xxxx-yyyyyyyy"
  ]

  tags_common = {
    Environment = "shared"
  }
}
```

### Example Without Region Prefix

```hcl
module "transit_gateway" {
  source = "github.com/jhonmezaa/terraform-aws-transit-gateway//transit-gateway?ref=v1.2.0"

  account_name      = "shared"
  project_name      = "myapp"
  use_region_prefix = false  # Names will be: tgw-shared-myapp, tgwrtb-shared-myapp, etc.

  tags_common = {
    Environment = "production"
  }
}
```

### Disabling RAM Sharing

If you don't need to share the Transit Gateway or if AWS Organizations is not enabled:

```hcl
module "transit_gateway" {
  source = "github.com/jhonmezaa/terraform-aws-transit-gateway//transit-gateway?ref=v1.2.0"

  account_name = "shared"
  project_name = "myapp"

  share_tgw = false  # Disable RAM sharing

  tags_common = {
    Environment = "production"
  }
}
```

## Tags

Every resource is tagged with:

```hcl
merge(var.tags_common, <resource tags>, { Name = <generated name>, ManagedBy = "Terraform" })
```

`<resource tags>` is `tgw_tags`, `tgw_route_table_tags`, `ram_tags` or `tgw_default_route_table_tags`. `Name` and `ManagedBy` always win.

**Example** with `tags_common = { Environment = "production", Owner = "Cloud-Team" }` in `us-east-2`:

```hcl
{
  Environment = "production"
  Owner       = "Cloud-Team"
  Name        = "ause2-tgw-shared-myapp"
  ManagedBy   = "Terraform"
}
```

## Examples

- [basic](./examples/basic): Transit Gateway and custom route table, without RAM sharing
- [cross-account](./examples/cross-account): Transit Gateway shared through RAM
- [vpn-integration](./examples/vpn-integration): Transit Gateway prepared for Site-to-Site VPN

## Architecture

This module creates the following AWS resources:

```
┌─────────────────────────────────────────────────────────┐
│  Transit Gateway Module                                 │
│                                                          │
│  ┌────────────────────────────────────────────┐        │
│  │  Transit Gateway                           │        │
│  │  Name: {region}-tgw-{account}-{project}    │        │
│  │  ASN: 64512                                │        │
│  └────────────────────────────────────────────┘        │
│                      │                                  │
│                      ▼                                  │
│  ┌────────────────────────────────────────────┐        │
│  │  Transit Gateway Route Table               │        │
│  │  Name: {region}-tgwrtb-{account}-{project} │        │
│  └────────────────────────────────────────────┘        │
│                      │                                  │
│                      ▼                                  │
│  ┌────────────────────────────────────────────┐        │
│  │  RAM Resource Share (Optional)             │        │
│  │  Name: {region}-ramshare-{account}-{project}│       │
│  │  - Share with AWS Accounts                 │        │
│  │  - Share with Organization                 │        │
│  │  - Share with Organizational Units         │        │
│  └────────────────────────────────────────────┘        │
└─────────────────────────────────────────────────────────┘
```

## VPC Attachments

**Note:** This module creates the Transit Gateway infrastructure only. VPC attachments should be created in your VPC modules when creating VPCs. This separation of concerns allows:

- Better modularity and reusability
- Independent lifecycle management of VPCs and Transit Gateway
- Clearer ownership and responsibility boundaries

## Contributing

When contributing to this module:

1. Follow the existing file naming convention (numbered prefixes)
2. Update documentation for any new variables or outputs
3. Test changes in both Terraform and Terragrunt examples
4. Use conventional commits for commit messages
5. Update CHANGELOG.md for significant changes

## License

MIT License - See LICENSE file for details.

## Authors

- Jhon Meza

## Support

For issues, questions, or contributions, please open an issue in the repository.
