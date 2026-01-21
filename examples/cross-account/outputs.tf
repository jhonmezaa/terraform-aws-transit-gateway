output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = module.tgw.ec2_transit_gateway_id
}

output "transit_gateway_arn" {
  description = "Transit Gateway ARN"
  value       = module.tgw.ec2_transit_gateway_arn
}

output "ram_resource_share_id" {
  description = "RAM Resource Share ID"
  value       = module.tgw.ram_resource_share_id
}

output "ram_principal_association_id" {
  description = "RAM Principal Association IDs"
  value       = module.tgw.ram_principal_association_id
}
