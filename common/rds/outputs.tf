output "rds_01_arn" {
  value = module.rds_01.rds_cluster_arn
}

output "rds_01_endpoint" {
  value = module.rds_01.rds_cluster_endpoint
}

output "rds_01_port" {
  value = module.rds_01.rds_cluster_port
}