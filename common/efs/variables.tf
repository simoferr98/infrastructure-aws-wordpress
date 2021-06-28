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
variable "sg_efs_01_name" {}
variable "vpc_01_private_subnets" {
  type = list(string)
}