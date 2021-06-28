#------------------------
#sg_alb_01
#------------------------
module "sg_alb_01" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.2.0"

  vpc_id          = var.vpc_01_id
  name            = "${var.project}-sg-alb-01"
  use_name_prefix = false
  description     = "SG for alb_01"

  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.common_tags
}

#------------------------
#sg_ecs_01
#------------------------
module "sg_ecs_01" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.2.0"

  vpc_id          = var.vpc_01_id
  name            = "${var.project}-sg-ecs-01"
  use_name_prefix = false
  description     = "SG for ecs_01"

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      description              = "Access from ALB"
      source_security_group_id = module.sg_alb_01.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.common_tags
}

#------------------------
#sg_rds_01
#------------------------
module "sg_rds_01" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "4.2.0"
  name            = "${var.project}-sg-rds-01"
  vpc_id          = var.vpc_01_id
  use_name_prefix = false
  description     = "SG for rds_01"

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.sg_ecs_01.security_group_id
      description              = "Access from ECS"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.common_tags
}

#------------------------
#sg_efs_01
#------------------------
module "sg_efs_01" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "4.2.0"
  name            = "${var.project}-sg-efs-01"
  vpc_id          = var.vpc_01_id
  use_name_prefix = false
  description     = "SG for efs_01"

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "nfs-tcp"
      source_security_group_id = module.sg_ecs_01.security_group_id
      description              = "Access from ECS"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.common_tags
}