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
variable "sg_rds_01_id" {}
variable "sg_rds_01_name" {}
variable "vpc_01_database_subnets" {
  type = list(string)
}
variable "vpc_01_id" {}

#------------------------
#local variables
#------------------------
variable "usernamedb" {}

variable "passworddb" {}

variable "database_name" {}

variable "rds_01_engine" {}

variable "rds_01_engine_version" {}

variable "rds_01_family" {}

variable "rds_01_replica_scale_enabled" {}

variable "rds_01_replica_count" {}

variable "rds_01_scaling_configuration_db_autopause" {}

variable "rds_01_scaling_configuration_db_min_capacity" {}

variable "rds_01_scaling_configuration_db_max_capacity" {}

variable "rds_01_scaling_configuration_db_autopause_after_seconds" {}

variable "rds_01_timeout_action" {}

variable "rds_01_deletion_protection" {}

variable "rds_01_storage_encrypted" {}