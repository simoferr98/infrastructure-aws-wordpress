#------------------------
#terraform root variables
#------------------------
variable "region" {}
variable "account_id" {}
variable "vpc_azs" {
  type = list(string)
}
variable "project" {}
variable "common_tags" {
  type = map(string)
}

#------------------------
#terragrunt.hcl local variables
#------------------------
variable "sg_efs_01_id" {}
variable "sg_ecs_01_id" {}
variable "vpc_01_private_subnets" {
  type = list(string)
}
variable "efs_01_id" {}
variable "alb_01_target_group_arns" {}
variable "ssm_parameter_01_arn" {}
variable "ssm_parameter_02_arn" {}
variable "rds_01_endpoint" {}
variable "role_01" {}
variable "role_02" {}

#------------------------
#local variables
#------------------------
variable "cloudwatch_log_group_01_log_retention_in_days" {}

variable "task_definition_01_task_cpu" {}

variable "task_definition_01_task_memory" {}

variable "task_definition_01_container_image_url" {}

variable "container_port" {}

variable "container_name" {}

variable "database_name" {}

variable "service_ecs_01_desired_count" {}

variable "appautoscaling_target_01_min_capacity" {}

variable "appautoscaling_target_01_max_capacity" {}

variable "appautoscaling_target_01_ecs_service_autoscaling_cpu_average_utilization_target" {}

variable "appautoscaling_target_01_ecs_service_autoscaling_scale_in_cooldown" {}

variable "appautoscaling_target_01_ecs_service_autoscaling_scale_out_cooldown" {}