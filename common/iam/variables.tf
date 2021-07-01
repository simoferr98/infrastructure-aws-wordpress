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
variable "efs_01_arn" {}