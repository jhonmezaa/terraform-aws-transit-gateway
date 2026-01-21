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
  source = "../../terraform-aws-vpn/vpn"

  # Use Transit Gateway ID from this example
  transit_gateway_id = module.tgw.transit_gateway_id

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

## Cost Estimation

- Transit Gateway: ~$36/month
- Data processing: $0.02/GB
- VPN Connection (separate): ~$36/month

Total: ~$72/month + data transfer costs
