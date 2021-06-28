#------------------------
#create alb_01
#------------------------
module "alb_01" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.2.0"

  name               = "${var.project}-public-alb-01"
  load_balancer_type = "application"
  vpc_id             = var.vpc_01_id
  subnets            = var.vpc_01_public_subnets
  security_groups    = [var.sg_alb_01_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name             = "${var.project}-ecs"
      backend_protocol = "HTTP"
      backend_port     = var.container_port
      target_type      = "ip"
      health_check = {
        enabled = true
        path    = "/"
        matcher = "200,302"
      }
    }
  ]

  tags = var.common_tags
}