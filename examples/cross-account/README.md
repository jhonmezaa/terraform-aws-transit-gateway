# Cross-Account Transit Gateway

This example creates a Transit Gateway in a shared networking account and shares it with other accounts, an AWS Organization or an OU through AWS Resource Access Manager (RAM).

## Resources created

| Resource | Name (in `us-east-1` with the default variables) |
| --- | --- |
| Transit Gateway | `ause1-tgw-shared-network` |
| Transit Gateway route table | `ause1-tgwrtb-shared-network` |
| RAM resource share | `ause1-ramshare-shared-network` |
| RAM resource association | - |
| RAM principal association | one per entry in `ram_principals` |

## Prerequisites

- To share with an Organization or OU, enable RAM sharing with AWS Organizations.
- `ram_allow_external_principals = false` only allows principals inside your organization.
- Attachments from other accounts are accepted automatically (`enable_auto_accept_shared_attachments = true`).

## Usage

```bash
terraform init
terraform plan -var='ram_principals=["123456789012"]'
terraform apply -var='ram_principals=["123456789012"]'
```

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| account_name | Account name for naming resources | `string` | `"shared"` |
| project_name | Project name for naming resources | `string` | `"network"` |
| ram_principals | List of principals to share Transit Gateway with | `list(string)` | `[]` |
| tags_common | Common tags for all resources | `map(string)` | see `variables.tf` |

## Outputs

| Name | Description |
| --- | --- |
| transit_gateway_id | Transit Gateway ID |
| transit_gateway_arn | Transit Gateway ARN |
| ram_resource_share_id | RAM Resource Share ID |
| ram_principal_association_id | RAM Principal Association ID (first principal) |
