#------------------------
#create vpc_01 and subnet
#------------------------
module "vpc_01" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.1.0"

  name = "${var.project}-vpc"
  cidr = var.vpc_01_vpc_cidr
  azs  = var.vpc_azs

  enable_dns_hostnames = true

  private_subnets  = var.vpc_01_private_subnets_value
  public_subnets   = var.vpc_01_public_subnets_value
  database_subnets = var.vpc_01_database_subnets_value

  create_database_subnet_group = false
  enable_nat_gateway           = true
  single_nat_gateway           = false
  one_nat_gateway_per_az       = false

  tags = var.common_tags
}