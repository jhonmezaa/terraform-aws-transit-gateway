# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-21

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

[1.0.0]: https://github.com/jhonmezaa/terraform-aws-transit-gateway/releases/tag/v1.0.0
