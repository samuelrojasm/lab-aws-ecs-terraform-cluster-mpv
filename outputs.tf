# Outputs para mantener compatibilidad con el resto de tu infraestructura
#---------------------------------------------------------------------------
output "vpc_id" {
  description = "ID de la VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block de la VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "Lista de IDs de las subnets privadas"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Lista de IDs de las subnets públicas"
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "Lista de IDs de las subnets de base de datos"
  value       = module.vpc.database_subnets
}

output "internet_gateway_id" {
  description = "ID del Internet Gateway"
  value       = module.vpc.igw_id
}

output "nat_gateway_ids" {
  description = "Lista de IDs de los NAT Gateways"
  value       = module.vpc.natgw_ids
}



