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

| AWS Region       | Code  |
|------------------|-------|
| us-east-1        | ause1 |
| us-east-2        | ause2 |
| us-west-1        | ausw1 |
| us-west-2        | ausw2 |
| eu-west-1        | euwe1 |
| eu-central-1     | euce1 |
| ap-southeast-1   | apse1 |
| ap-northeast-1   | apne1 |
| sa-east-1        | saea1 |

### Resource Types

| Resource                      | Code      |
|-------------------------------|-----------|
| Transit Gateway               | tgw       |
| Transit Gateway Route Table   | tgwrtb    |
| RAM Resource Share            | ramshare  |

### Example Names

For a deployment in `us-east-2` (Ohio) with `account_name = "shared"` and `project_name = "myapp"`:

- Transit Gateway: `ause2-tgw-shared-myapp`
- TGW Route Table: `ause2-tgwrtb-shared-myapp`
- RAM Share: `ause2-ramshare-shared-myapp`

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.7 |
| aws | >= 6.0 |

## Usage

### Basic Example with Terraform

```hcl
provider "aws" {
  region = "us-east-2"
}

module "transit_gateway" {
  source = "path/to/tf-module-core-networking-aws-transit-gateway"

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
    ManagedBy   = "Terraform"
    Owner       = "Cloud-Team"
    CostCenter  = "IT-Infrastructure"
  }
}
```

### Example with Terragrunt

See the [example/terragrunt](./example/terragrunt) directory for a complete Terragrunt implementation with:
- Environment-specific configuration via `env.hcl`
- Automatic backend configuration for remote state
- DRY configuration management

### Example with RAM Sharing

```hcl
module "transit_gateway" {
  source = "path/to/tf-module-core-networking-aws-transit-gateway"

  account_name = "shared"
  project_name = "myapp"
  description  = "Shared Transit Gateway for multi-account architecture"

  # RAM Configuration
  share_tgw                     = true
  ram_name                      = "tgw-share"
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

## Inputs

### Required Inputs

| Name | Description | Type |
|------|-------------|------|
| account_name | Account name to be used in resource naming (e.g., 'shared', 'prod', 'dev') | `string` |
| project_name | Project name to be used in resource naming (e.g., 'myapp', 'core') | `string` |

### Optional Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| create_tgw | Controls if Transit Gateway should be created | `bool` | `true` |
| description | Description of the Transit Gateway | `string` | `null` |
| amazon_side_asn | Private Autonomous System Number (ASN) for the Amazon side of a BGP session | `string` | `null` |
| enable_default_route_table_association | Whether resource attachments are automatically associated with the default association route table | `bool` | `true` |
| enable_default_route_table_propagation | Whether resource attachments automatically propagate routes to the default propagation route table | `bool` | `true` |
| enable_auto_accept_shared_attachments | Whether resource attachment requests are automatically accepted | `bool` | `false` |
| enable_vpn_ecmp_support | Whether VPN Equal Cost Multipath Protocol support is enabled | `bool` | `true` |
| enable_multicast_support | Whether Multicast support is enabled | `bool` | `false` |
| enable_dns_support | Whether DNS support is enabled | `bool` | `true` |
| enable_sg_referencing_support | Whether security group referencing support is enabled | `bool` | `true` |
| transit_gateway_cidr_blocks | One or more IPv4 or IPv6 CIDR blocks for the transit gateway | `list(string)` | `[]` |
| create_tgw_routes | Controls if Transit Gateway route table should be created | `bool` | `true` |
| transit_gateway_route_table_id | Identifier of EC2 Transit Gateway Route Table to use when creating attachments | `string` | `null` |
| share_tgw | Whether to share the Transit Gateway with other accounts using Resource Access Manager | `bool` | `true` |
| ram_name | Name of the resource share for the Transit Gateway | `string` | `""` |
| ram_allow_external_principals | Whether to allow external principals for the resource share | `bool` | `false` |
| ram_principals | List of principals to share the Transit Gateway with (AWS Account IDs, Organization ARNs, OU ARNs) | `list(string)` | `[]` |
| ram_resource_share_arn | ARN of the Resource Share that will be used to share the Transit Gateway | `string` | `""` |
| tags_common | Common tags to be applied to all resources | `map(string)` | `{}` |
| timeouts | Create, update, and delete timeout configurations for the transit gateway | `object` | `null` |

## Outputs

| Name | Description |
|------|-------------|
| transit_gateway_id | EC2 Transit Gateway identifier |
| transit_gateway_arn | EC2 Transit Gateway ARN |
| transit_gateway_owner_id | Identifier of the AWS account that owns the EC2 Transit Gateway |
| transit_gateway_association_default_route_table_id | Identifier of the default association route table |
| transit_gateway_propagation_default_route_table_id | Identifier of the default propagation route table |
| transit_gateway_route_table_id | EC2 Transit Gateway Route Table identifier |
| ram_resource_share_id | The Amazon Resource Name (ARN) of the resource share |
| ram_principal_association_id | The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma |

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
  source = "path/to/module"

  account_name = "shared"
  project_name = "myapp"

  share_tgw      = true
  ram_name       = "tgw-share"
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
  source = "path/to/module"

  account_name = "shared"
  project_name = "myapp"

  share_tgw      = true
  ram_name       = "tgw-org-share"
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
  source = "path/to/module"

  account_name = "shared"
  project_name = "myapp"

  share_tgw      = true
  ram_name       = "tgw-ou-share"
  ram_principals = [
    "arn:aws:organizations::111111111111:ou/o-xxxxxxxxxx/ou-xxxx-yyyyyyyy"
  ]

  tags_common = {
    Environment = "shared"
  }
}
```

### Disabling RAM Sharing

If you don't need to share the Transit Gateway or if AWS Organizations is not enabled:

```hcl
module "transit_gateway" {
  source = "path/to/module"

  account_name = "shared"
  project_name = "myapp"

  share_tgw = false  # Disable RAM sharing

  tags_common = {
    Environment = "production"
  }
}
```

## Tags

All resources are tagged using the `tags_common` variable. The module automatically adds a `Name` tag following the naming convention.

**Tag Merge Order:**
1. **Name tag** (auto-generated): `{region}-{resource_type}-{account_name}-{project_name}`
2. **tags_common** (user-provided common tags)

**Example:**

```hcl
tags_common = {
  Environment = "production"
  Project     = "Infrastructure"
  ManagedBy   = "Terraform"
  Owner       = "Cloud-Team"
  CostCenter  = "IT-Infrastructure"
}
```

**Resulting tags on Transit Gateway:**

```hcl
{
  Name        = "ause2-tgw-shared-myapp"  # Auto-generated
  Environment = "production"              # From tags_common
  Project     = "Infrastructure"          # From tags_common
  ManagedBy   = "Terraform"               # From tags_common
  Owner       = "Cloud-Team"              # From tags_common
  CostCenter  = "IT-Infrastructure"       # From tags_common
}
```

## Examples

Complete examples are available in the [example](./example) directory:

- **[Terraform Example](./example/terraform)**: Standard Terraform implementation
- **[Terragrunt Example](./example/terragrunt)**: DRY Terragrunt configuration with remote state

## Adding New Regions

To add support for new AWS regions, update the `region_prefix` map in `9-locals.tf`:

```hcl
locals {
  region_prefix = {
    "us-east-1"      = "ause1"
    "us-east-2"      = "ause2"
    # Add new regions here
    "eu-west-2"      = "euwe2"
    "ap-south-1"     = "apso1"
  }
}
```

If a region is not found in the map, the module will use `"unkn"` as the region code.

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
