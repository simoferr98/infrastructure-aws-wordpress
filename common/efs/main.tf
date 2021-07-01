#------------------------
#create efs_01 for cluster ECS
#------------------------
resource "aws_efs_file_system" "efs_01" {
  creation_token   = "${var.project}-efs-01-data"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = merge({
    Name = "${var.project}-efs-01-data"
    }, var.common_tags
  )
}

#------------------------
#create mount_target_01 for efs_01
#------------------------
resource "aws_efs_mount_target" "efs_01_mount_target_01" {
  count           = length(var.vpc_01_private_subnets)
  file_system_id  = aws_efs_file_system.efs_01.id
  subnet_id       = var.vpc_01_private_subnets[count.index]
  security_groups = [var.sg_efs_01_id]
}