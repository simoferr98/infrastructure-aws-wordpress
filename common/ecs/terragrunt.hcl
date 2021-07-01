include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../security-group",
    "../vpc",
    "../efs",
    "../alb",
    "../ssm",
    "../rds",
    "../iam",
    "../cloudwatch"
  ]
}

dependency "security-group" {
  config_path = "../security-group"
  mock_outputs = {
    sg_efs_01_id = ["temporary-dummy-id"]
    sg_ecs_01_id = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_01_private_subnets = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "efs" {
  config_path = "../efs"
  mock_outputs = {
    efs_01_id = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "alb" {
  config_path = "../alb"
  mock_outputs = {
    alb_01_target_group_arns = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "ssm" {
  config_path = "../ssm"
  mock_outputs = {
    ssm_parameter_01_arn = ["temporary-dummy-id"]
    ssm_parameter_02_arn = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "rds" {
  config_path = "../rds"
  mock_outputs = {
    rds_01_endpoint = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "iam" {
  config_path = "../iam"
  mock_outputs = {
    role_01 = ["temporary-dummy-id"]
    role_02 = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

dependency "cloudwatch" {
  config_path = "../cloudwatch"
  mock_outputs = {
    cloudwatch_log_group_01_name = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  sg_efs_01_id             = dependency.security-group.outputs.sg_efs_01_id
  sg_ecs_01_id             = dependency.security-group.outputs.sg_ecs_01_id
  vpc_01_private_subnets   = dependency.vpc.outputs.vpc_01_private_subnets
  efs_01_id                = dependency.efs.outputs.efs_01_id
  alb_01_target_group_arns = dependency.alb.outputs.alb_01_target_group_arns
  ssm_parameter_01_arn     = dependency.ssm.outputs.ssm_parameter_01_arn
  ssm_parameter_02_arn     = dependency.ssm.outputs.ssm_parameter_02_arn
  rds_01_endpoint          = dependency.rds.outputs.rds_01_endpoint
  role_01                  = dependency.iam.outputs.role_01
  role_02                  = dependency.iam.outputs.role_02
  cloudwatch_log_group_01_name = dependency.cloudwatch.outputs.cloudwatch_log_group_01_name
}