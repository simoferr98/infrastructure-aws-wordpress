#------------------------
#rds_01. We must create the subnet group and parameter group resources first.
#------------------------
resource "aws_db_subnet_group" "rds_db_subnet_group" {
  name        = "${var.project}-subnet-group"
  description = "Database subnet group for project ${var.project}"

  subnet_ids = var.vpc_01_database_subnets
  tags       = var.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "rds_parameter_group_01" {
  name        = "${var.project}-parameter-group"
  description = "Custom DB Parameter Group for ${var.project}-db - Project ${var.project}"
  family      = var.rds_01_family
  tags        = var.common_tags
}

resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group_01" {
  name        = "${var.project}-aurora-cluster-parameter-group"
  family      = var.rds_01_family
  description = "${var.project}-aurora-cluster-parameter-group"
  tags        = var.common_tags
}

#------------------------
#rds_01
#mysql-aurora
#------------------------
module "rds_01" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "5.2.0"

  name              = "${var.project}-db"
  engine            = var.rds_01_engine
  engine_mode       = "serverless"
  storage_encrypted = var.rds_01_storage_encrypted
  engine_version    = var.rds_01_engine_version

  vpc_id                 = var.vpc_01_id
  subnets                = var.vpc_01_database_subnets
  db_subnet_group_name   = aws_db_subnet_group.rds_db_subnet_group.name
  vpc_security_group_ids = [var.sg_rds_01_id]

  replica_scale_enabled = var.rds_01_replica_scale_enabled
  replica_count         = var.rds_01_replica_count

  db_parameter_group_name         = aws_db_parameter_group.rds_parameter_group_01.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds_cluster_parameter_group_01.id

  database_name          = var.database_name
  create_random_password = false
  username               = var.usernamedb
  password               = var.passworddb

  scaling_configuration = {
    auto_pause               = var.rds_01_scaling_configuration_db_autopause
    min_capacity             = var.rds_01_scaling_configuration_db_min_capacity
    max_capacity             = var.rds_01_scaling_configuration_db_max_capacity
    seconds_until_auto_pause = var.rds_01_scaling_configuration_db_autopause_after_seconds
    timeout_action           = var.rds_01_timeout_action
  }

  deletion_protection    = var.rds_01_deletion_protection
  create_monitoring_role = false
  apply_immediately      = true
  skip_final_snapshot    = true
  create_security_group  = false
  tags                   = var.common_tags
}