# Transit Gateway for VPN Integration

This example creates a Transit Gateway optimized for Site-to-Site VPN connectivity.

## Features

- Transit Gateway with VPN ECMP support
- DNS resolution across VPN connections
- BGP ASN configuration (64512)
- Auto-accept attachments (optional)
- Security group referencing support
- Default route table association and propagation

## Usage

### Deploy

```bash
terraform init
terraform plan
terraform apply
```

### Use with VPN Module

After creating the Transit Gateway, use its ID with the VPN module:

```hcl
module "vpn" {
  source = "github.com/jhonmezaa/terraform-aws-vpn//vpn?ref=v1.3.5"

  account_name = "prod"
  project_name = "vpn"

  # Use the Transit Gateway created by this example
  use_existing_transit_gateway = true
  transit_gateway_id           = module.tgw.ec2_transit_gateway_id
  transit_gateway_subnet_ids   = ["subnet-aaaa", "subnet-bbbb"]

  # VPN configuration
  customer_gateway_bgp_asn    = 65000
  customer_gateway_ip_address = "203.0.113.1"

  # Other VPN settings...
}
```

## Outputs

- `transit_gateway_id` - Use this for VPN attachment
- `transit_gateway_arn` - Transit Gateway ARN
- `transit_gateway_route_table_id` - Route table ID for manual routing
- `transit_gateway_owner_id` - Owner account ID of the Transit Gateway
- `transit_gateway_association_default_route_table_id` - Default association route table ID
- `transit_gateway_propagation_default_route_table_id` - Default propagation route table ID

## Cost Estimation

- Transit Gateway: ~$36/month
- Data processing: $0.02/GB
- VPN Connection (separate): ~$36/month

Total: ~$72/month + data transfer costs
