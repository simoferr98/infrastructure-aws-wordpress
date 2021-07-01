output "alb_01_target_group_arns" {
  value = module.alb_01.target_group_arns[0]
}

output "alb_01_target_group_names" {
  value = module.alb_01.target_group_names[0]
}

output "alb_01_lb_arn" {
  value = module.alb_01.lb_arn
}

output "alb_01_lb_dns_name" {
  value = module.alb_01.lb_dns_name
}