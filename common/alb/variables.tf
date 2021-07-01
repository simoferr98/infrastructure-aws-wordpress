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
variable "sg_alb_01_id" {}
variable "sg_alb_01_name" {}
variable "vpc_01_public_subnets" {
  type = list(string)
}
variable "vpc_01_id" {}

#------------------------
#local variables
#------------------------
variable "container_port" {}