#!/bin/bash
#------------------------
#terragrunt.hcl local variables
#------------------------
export TF_VAR_project_name=wordpress
export TF_VAR_region=eu-central-1
export TF_VAR_vpc_azs='["eu-central-1a", "eu-central-1b", "eu-central-1c"]'

#------------------------
#common local variables
#------------------------
export TF_VAR_usernamedb=admindb
export TF_VAR_passworddb=password
export TF_VAR_database_name=wordpressdb
export TF_VAR_container_port=80
export TF_VAR_container_name=wp-app

#------------------------
#local variables vpc
#------------------------
export TF_VAR_vpc_01_vpc_cidr=13.0.0.0/16
export TF_VAR_vpc_01_public_subnets_value='["13.0.0.0/22","13.0.8.0/22","13.0.4.0/22"]'
export TF_VAR_vpc_01_private_subnets_value='["13.0.32.0/21","13.0.40.0/21","13.0.48.0/21"]'
export TF_VAR_vpc_01_database_subnets_value='["13.0.64.0/23","13.0.66.0/23","13.0.68.0/23"]'

#------------------------
#local variables rds
#------------------------
export TF_VAR_rds_01_family=aurora-mysql5.7
export TF_VAR_rds_01_engine=aurora-mysql
export TF_VAR_rds_01_engine_version=5.7
export TF_VAR_rds_01_replica_scale_enabled=false
export TF_VAR_rds_01_replica_count=0
export TF_VAR_rds_01_scaling_configuration_db_autopause=1
export TF_VAR_rds_01_scaling_configuration_db_min_capacity=2
export TF_VAR_rds_01_scaling_configuration_db_max_capacity=4
export TF_VAR_rds_01_scaling_configuration_db_autopause_after_seconds=3600
export TF_VAR_rds_01_timeout_action=RollbackCapacityChange
export TF_VAR_rds_01_deletion_protection=true
export TF_VAR_rds_01_storage_encrypted=true

#------------------------
#local variables ecs
#-----------------------
export TF_VAR_cloudwatch_log_group_01_log_retention_in_days=7
export TF_VAR_task_definition_01_task_cpu=1024
export TF_VAR_task_definition_01_task_memory=2048
export TF_VAR_task_definition_01_container_image_url=wordpress:5.7.2-php7.3-apache
export TF_VAR_service_ecs_01_desired_count=2
export TF_VAR_appautoscaling_target_01_min_capacity=2
export TF_VAR_appautoscaling_target_01_max_capacity=10
export TF_VAR_appautoscaling_target_01_ecs_service_autoscaling_cpu_average_utilization_target=50
export TF_VAR_appautoscaling_target_01_ecs_service_autoscaling_scale_in_cooldown=300
export TF_VAR_appautoscaling_target_01_ecs_service_autoscaling_scale_out_cooldown=300
