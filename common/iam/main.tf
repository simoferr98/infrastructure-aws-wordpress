#------------------------
#Amazon ECS role
#------------------------

#------------------------
#create the policy_01 and role_01
#ecs_task_execution_role role and associated its policy
#------------------------
data "aws_iam_policy_document" "ecs_task_execution" {
  statement {
    sid       = "AmazonECSTaskExecutionRolePolicy"
    actions   = ["ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "logs:CreateLogStream", "logs:PutLogEvents", "ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}

module "policy_01" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.1.0"

  name        = "${var.project}-ecs-task-execution"
  description = "Amazon ECS Task Execution Role Policy"
  policy      = data.aws_iam_policy_document.ecs_task_execution.json
}

module "role_01" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.1.0"

  role_name         = "${var.project}-ecs-task-execution"
  create_role       = true
  role_requires_mfa = false

  trusted_role_services = ["ecs-tasks.amazonaws.com"]

  custom_role_policy_arns = [module.policy_01.arn]

  number_of_custom_role_policy_arns = 1
}

#------------------------
#create the policy_02 and role_02
#ecs_task role and associated its policy
#------------------------
data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    sid       = "AmazonECSTaskExecutionRolePolicy"
    actions   = ["elasticfilesystem:ClientMount", "elasticfilesystem:ClientWrite"]
    resources = [var.efs_01_arn]
  }
}

module "policy_02" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.1.0"

  name        = "${var.project}-ecs-task"
  description = "Amazon ECS Task Role Policy"
  policy      = data.aws_iam_policy_document.ecs_task_policy.json
}

module "role_02" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.1.0"

  role_name         = "${var.project}-ecs-task"
  create_role       = true
  role_requires_mfa = false

  trusted_role_services = ["ecs-tasks.amazonaws.com"]

  custom_role_policy_arns = [module.policy_02.arn]

  number_of_custom_role_policy_arns = 1
}