#------------------------
#create cloudwatch_log_group_01
#------------------------
resource "aws_cloudwatch_log_group" "cloudwatch_log_group_01" {
  name              = "/${var.project}/ecs"
  tags              = var.common_tags
  retention_in_days = var.cloudwatch_log_group_01_log_retention_in_days
}