output "vpc_01_name" {
  value = module.vpc_01.name
}

output "vpc_01_id" {
  value = module.vpc_01.vpc_id
}

output "vpc_01_database_subnets" {
  value = module.vpc_01.database_subnets
}

output "vpc_01_private_subnets" {
  value = module.vpc_01.private_subnets
}

output "vpc_01_public_subnets" {
  value = module.vpc_01.public_subnets
}