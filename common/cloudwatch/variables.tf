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
#local variables
#------------------------
variable "cloudwatch_log_group_01_log_retention_in_days" {}