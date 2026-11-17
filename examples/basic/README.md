# Basic Transit Gateway

This example creates a single Transit Gateway and its custom route table, without RAM sharing (`share_tgw = false`).

## Resources created

| Resource | Name (in `us-east-1` with the default variables) |
| --- | --- |
| Transit Gateway | `ause1-tgw-dev-test` |
| Transit Gateway route table | `ause1-tgwrtb-dev-test` |

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| account_name | Account name for naming resources | `string` | `"dev"` |
| project_name | Project name for naming resources | `string` | `"test"` |
| tags_common | Common tags for all resources | `map(string)` | see `variables.tf` |

## Outputs

| Name | Description |
| --- | --- |
| transit_gateway_id | Transit Gateway ID |
| transit_gateway_arn | Transit Gateway ARN |
| transit_gateway_route_table_id | Transit Gateway Route Table ID |
