output "transit_gateway_id" {
  description = "Transit Gateway ID"
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
