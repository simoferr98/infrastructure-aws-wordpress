#------------------------
#create ssm_parameter_01 for usernamedb
#------------------------
resource "aws_ssm_parameter" "ssm_parameter_01" {
  name        = "/${var.project}/${var.project}-usernamedb"
  description = "${var.project} usernamedb"
  type        = "SecureString"
  value       = var.usernamedb
  tier        = "Standard"
  tags        = var.common_tags
}

#------------------------
#create ssm_parameter_02 for passworddb
#------------------------
resource "aws_ssm_parameter" "ssm_parameter_02" {
  name        = "/${var.project}/${var.project}-passworddb"
  description = "${var.project} passworddb"
  type        = "SecureString"
  value       = var.passworddb
  tier        = "Standard"
  tags        = var.common_tags
}