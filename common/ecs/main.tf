#------------------------
#create cluster_ecs_01
#------------------------
resource "aws_ecs_cluster" "cluster_ecs_01" {
  name = "${var.project}-cluster"
  tags = var.common_tags
}

#------------------------
#create task_definition_01
#------------------------
resource "aws_ecs_task_definition" "task_definition_01" {
  family                   = "${var.project}-task-definition"
  execution_role_arn       = var.role_01
  task_role_arn            = var.role_02
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_definition_01_task_cpu
  memory                   = var.task_definition_01_task_memory

  container_definitions = templatefile(
    "config_container/container_definition.json",
    {
      db_user         = var.ssm_parameter_01_arn,
      db_password     = var.ssm_parameter_02_arn,
      db_host         = var.rds_01_endpoint,
      db_name         = var.database_name
      container_image = var.task_definition_01_container_image_url,
      container_name  = var.container_name,
      container_port  = var.container_port,
      log_group       = var.cloudwatch_log_group_01_name,
      region          = var.region
    }
  )

  volume {
    name = "efs"
    efs_volume_configuration {
      file_system_id = var.efs_01_id
    }
  }
}

#------------------------
#create service_ecs_01
#------------------------
resource "aws_ecs_service" "service_ecs_01" {
  name    = "${var.project}-service"
  cluster = aws_ecs_cluster.cluster_ecs_01.id

  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  task_definition = aws_ecs_task_definition.task_definition_01.arn

  desired_count = var.service_ecs_01_desired_count

  network_configuration {
    security_groups = [var.sg_efs_01_id, var.sg_ecs_01_id]
    subnets         = var.vpc_01_private_subnets
  }

  load_balancer {
    target_group_arn = var.alb_01_target_group_arns
    container_name   = var.container_name
    container_port   = var.container_port
  }

  tags = var.common_tags

  lifecycle {
    ignore_changes = [desired_count]
  }
}

#------------------------
#create appautoscaling_target_01 and appautoscaling_policy_01
#------------------------
resource "aws_appautoscaling_target" "appautoscaling_target_01" {
  min_capacity       = var.appautoscaling_target_01_min_capacity
  max_capacity       = var.appautoscaling_target_01_max_capacity
  resource_id        = "service/${aws_ecs_cluster.cluster_ecs_01.name}/${aws_ecs_service.service_ecs_01.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "appautoscaling_policy_01" {
  name               = "${var.project}.fargate-service-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.appautoscaling_target_01.id
  scalable_dimension = aws_appautoscaling_target.appautoscaling_target_01.scalable_dimension
  service_namespace  = aws_appautoscaling_target.appautoscaling_target_01.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.appautoscaling_target_01_ecs_service_autoscaling_cpu_average_utilization_target
    scale_in_cooldown  = var.appautoscaling_target_01_ecs_service_autoscaling_scale_in_cooldown
    scale_out_cooldown = var.appautoscaling_target_01_ecs_service_autoscaling_scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}