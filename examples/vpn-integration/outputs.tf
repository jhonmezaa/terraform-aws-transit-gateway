output "transit_gateway_id" {
  description = "Transit Gateway ID for VPN attachment"
  value       = module.tgw.ec2_transit_gateway_id
}

output "transit_gateway_arn" {
  description = "Transit Gateway ARN"
  value       = module.tgw.ec2_transit_gateway_arn
}

output "transit_gateway_route_table_id" {
  description = "Transit Gateway Route Table ID"
  value       = module.tgw.ec2_transit_gateway_route_table_id
}

output "transit_gateway_owner_id" {
  description = "Owner account ID of the Transit Gateway"
  value       = module.tgw.ec2_transit_gateway_owner_id
}

output "transit_gateway_association_default_route_table_id" {
  description = "Default association route table ID"
  value       = module.tgw.ec2_transit_gateway_association_default_route_table_id
}

output "transit_gateway_propagation_default_route_table_id" {
  description = "Default propagation route table ID"
  value       = module.tgw.ec2_transit_gateway_propagation_default_route_table_id
}
