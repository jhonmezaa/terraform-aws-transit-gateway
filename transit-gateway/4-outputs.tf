################################################################################
# Transit Gateway Outputs
################################################################################

output "ec2_transit_gateway_arn" {
  description = "EC2 Transit Gateway ARN"
  value       = try(aws_ec2_transit_gateway.this[0].arn, null)
}

output "ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway ID"
  value       = try(aws_ec2_transit_gateway.this[0].id, null)
}

output "ec2_transit_gateway_owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = try(aws_ec2_transit_gateway.this[0].owner_id, null)
}

output "ec2_transit_gateway_association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = try(aws_ec2_transit_gateway.this[0].association_default_route_table_id, null)
}

output "ec2_transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = try(aws_ec2_transit_gateway.this[0].propagation_default_route_table_id, null)
}

################################################################################
# Route Table Outputs
################################################################################

output "ec2_transit_gateway_route_table_id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = try(aws_ec2_transit_gateway_route_table.this[0].id, null)
}

output "ec2_transit_gateway_route_table_default_association_route_table" {
  description = "Boolean whether this is the default association route table for the EC2 Transit Gateway"
  value       = try(aws_ec2_transit_gateway_route_table.this[0].default_association_route_table, null)
}

output "ec2_transit_gateway_route_table_default_propagation_route_table" {
  description = "Boolean whether this is the default propagation route table for the EC2 Transit Gateway"
  value       = try(aws_ec2_transit_gateway_route_table.this[0].default_propagation_route_table, null)
}

################################################################################
# Resource Access Manager Outputs
################################################################################

output "ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = try(aws_ram_resource_share.this[0].id, null)
}

output "ram_principal_association_id" {
  description = "The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma"
  value       = try(aws_ram_principal_association.this[0].id, null)
}
