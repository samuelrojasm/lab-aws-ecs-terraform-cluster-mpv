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

output "private_subnets_ids" {
  description = "Lista de IDs de las subnets privadas"
  value       = module.vpc.private_subnets
}

output "public_subnets_ids" {
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

output "private_route_table_ids" {
  description = "Lista de IDs de route tables privadas"
  value       = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  description = "Lista de IDs de route tables públicas"
  value       = module.vpc.public_route_table_ids
}

output "alb_sg_id" {
  description = "El ID del Security Group del Application Load Balancer"
  value       = module.alb_security_group.security_group_id
}

output "fargate_sg_id" {
  description = "El ID del Security Group de las tareas de Fargate"
  value       = module.ecs_tasks_sg.security_group_id
}

output "ecs_task_execution_role_arn" {
  description = "El ARN del rol de ejecución de la tarea de ECS."
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "El ARN del rol de la tarea de ECS."
  value       = aws_iam_role.ecs_task_role.arn
}

output "alb_dns_name" {
  description = "El nombre DNS del Application Load Balancer"
  value       = aws_lb.main.dns_name
}
