# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.2.0] - 2026-11-17

### Added

- `enable_encryption_support` (bool, default `null`) to set `encryption_support` on the Transit Gateway (parity with upstream `terraform-aws-modules/transit-gateway` v3.3.0). `null` leaves the AWS default untouched
- `tgw_default_route_table_tags` (opt-in): when non-empty, the AWS-created default association route table is tagged through `aws_ec2_tag` with `tags_common` + these tags + `Name = {prefix}-tgwrtb-{account}-{project}-default` + `ManagedBy`. New output `ec2_transit_gateway_default_route_table_tags`
- `region` variable (provider v6 per-resource region) applied to every resource and to the `aws_region` data source used for naming
- `region_prefix` variable to override the region code used in names
- `name` and `tgw_route_table_name` variables to override the generated Name tags
- `tgw_tags`, `tgw_route_table_tags` and `ram_tags` variables for per-resource tags
- Validation of `account_name` and `project_name` (1-32 characters, `^[a-z0-9-]+$`)
- Precondition: `ram_resource_share_arn` is required when `create_tgw = false` and `share_tgw = true`
- Full `region_prefix_map` (EU, AP, CA, MX, ME, AF and IL regions)
- `LICENSE` (MIT) and README files for the `basic` and `cross-account` examples

### Changed

- Minimum AWS provider raised to `>= 6.25` in the module (`~> 6.25` in examples), required by `encryption_support`
- Tags now follow `merge(tags_common, <resource tags>, { Name, ManagedBy = "Terraform" })`; `Name` can no longer be overridden by `tags_common`
- `ram_name` is now honored as an explicit RAM share name (it was previously ignored)

### Fixed

- README: inputs/outputs tables now match the code (outputs are `ec2_transit_gateway_*`), removed references to non-existent `example/` directories and `9-locals.tf`, updated requirements, tag order and `source` refs
- `vpn-integration` example README: use the published VPN module source and its actual inputs (`use_existing_transit_gateway`, `transit_gateway_id`, `transit_gateway_subnet_ids`)

### Upgrade notes

- Run `terraform init -upgrade` if your lock file pins an AWS provider older than 6.25.
- A `ManagedBy = "Terraform"` tag is added to all resources (in-place tag update, no recreation).
- In regions that were not in the previous map (e.g. `eu-west-2`, `ap-south-1`, `ca-central-1`), the prefix changes from `unkn` to the real code: the Name tags and the RAM share name change in place (no recreation). Set `region_prefix = "unkn"` to keep the old names.
- If you were setting `ram_name`, the RAM share is renamed in place to that value. Remove `ram_name` to keep the generated name.
- If `tags_common` contained a `Name` key, it no longer overrides the generated Name tag.

## [v1.1.3] - 2026-10-27

### Changed

- Normalize CHANGELOG: preamble moved to the top, all headings use the `## [vX.Y.Z] - YYYY-MM-DD` format, entries sorted by version (newest first)
- Add missing entry for v1.1.1, reconstructed from git history

### Fixed

- Replace placeholder `source` paths (`path/to/...`) in README usage examples with `github.com/jhonmezaa/terraform-aws-transit-gateway//transit-gateway?ref=v1.1.2`

## [v1.1.2] - 2026-10-27

### Changed

- Use minimum-only version constraints in the reusable module, following HashiCorp guidance for shared modules: AWS provider `~> 6.0` -> `>= 6.0`
- Set module `required_version` to `>= 1.3` (was `~> 1.0`): the module uses `optional()` object type attributes (with defaults), which require Terraform 1.3; no newer features (`moved`/`import`/`check`/`removed`, cross-variable validations, provider-defined functions, ephemeral resources) are used
- Examples (root modules) keep pessimistic constraints: `required_version` `~> 1.3`, AWS provider `~> 6.0`
- Update Terraform and provider requirements in README

## [v1.1.1] - 2026-02-28

### Changed

- Update README and CHANGELOG documentation

## [v1.1.0] - 2026-02-27

### Added

- `use_region_prefix` boolean variable (default: `true`) to control whether the region prefix is included in resource names. When `false`, names omit the prefix

## [v1.0.2] - 2026-02-27

### Changed

- Standardize Terraform `required_version` to `~> 1.0` across module and examples

## [v1.0.1] - 2026-02-27

### Changed

- Update AWS provider constraint to `~> 6.0` across module and examples

## [v1.0.0] - 2026-01-21

### Added

#### Core Features

- **AWS Transit Gateway resource creation** with full configuration support
- **Transit Gateway Route Table management** for custom routing scenarios
- **Resource Access Manager (RAM) sharing** capabilities:
  - Support for sharing with AWS Account IDs
  - Support for sharing with AWS Organizations
  - Support for sharing with Organizational Units (OUs)
  - Support for external principals (cross-organization sharing)

#### Naming Convention and Automation

- **Automatic naming convention** following `{region_prefix}-{resource_type}-{account_name}-{project_name}` format
- **Auto-detection of AWS region** from provider configuration using data source
- **Region code mapping** for standardized resource naming:
  - `us-east-1` → `ause1`
  - `us-east-2` → `ause2`
  - `us-west-1` → `ausw1`
  - `us-west-2` → `ausw2`
  - `eu-west-1` → `euwe1`
  - `eu-central-1` → `euce1`
  - `ap-southeast-1` → `apse1`
  - `ap-northeast-1` → `apne1`
  - `sa-east-1` → `saea1`
- **Centralized tagging** with `tags_common` variable

#### Transit Gateway Features

- Custom Amazon Side ASN configuration
- Default route table association/propagation control
- Auto-accept shared attachments
- VPN ECMP support
- DNS support
- Multicast support
- Security group referencing support
- Transit Gateway CIDR blocks

#### Module Organization

- **Standardized file structure** with numbered files in `transit-gateway/` directory:
  - `0-versions.tf` - Terraform and provider version constraints
  - `1-transit-gateway.tf` - Transit Gateway resource
  - `2-tgw-route-table.tf` - Route table resources
  - `3-routes.tf` - Route configurations
  - `4-outputs.tf` - Module outputs
  - `5-variables.tf` - Input variables
  - `6-data.tf` - Data sources
  - `7-locals.tf` - Local values
  - `8-ram.tf` - Resource Access Manager sharing
- **Comprehensive outputs** for all resource identifiers and ARNs

#### Examples

- `examples/basic-transit-gateway/` - Basic Transit Gateway deployment
- `examples/transit-gateway-with-ram/` - RAM sharing with multiple account types
- Complete usage examples with both account IDs and Organizations/OUs

#### Documentation

- Complete `README.md` with usage examples
- Naming convention documentation
- RAM sharing guide and examples
- Input/Output reference tables
- Architecture patterns and best practices

### Configuration

**Required Variables:**

- `account_name` - Account name for resource naming
- `project_name` - Project name for resource naming

**Optional Variables:**

- All Transit Gateway features configurable via optional variables with sensible defaults
- Automatic resource naming without manual intervention
- Flexible RAM sharing configuration

### Technical Requirements

- **Terraform**: >= 1.5.7
- **AWS Provider**: >= 6.0

### Features Highlights

This module provides a production-ready Transit Gateway implementation with:

- ✅ Multi-account sharing via RAM
- ✅ Automatic resource naming following AWS best practices
- ✅ Complete Transit Gateway feature support
- ✅ Custom route table management
- ✅ Centralized tagging strategy
- ✅ Comprehensive examples for common scenarios

---

[v1.0.0]: https://github.com/jhonmezaa/terraform-aws-transit-gateway/releases/tag/v1.0.0
