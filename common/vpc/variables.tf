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
variable "vpc_01_vpc_cidr" {}

variable "vpc_01_public_subnets_value" {
  type = list(string)
}

variable "vpc_01_private_subnets_value" {
  type = list(string)
}

variable "vpc_01_database_subnets_value" {
  type = list(string)
}