include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../security-group",
    "../vpc"
  ]
}

dependency "security-group" {
  config_path = "../security-group"
  mock_outputs = {
    sg_alb_01_id   = ["temporary-dummy-id"]
    sg_alb_01_name = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["validate"]
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_01_id             = "temporary-dummy-id"
    vpc_01_public_subnets = "temporary-dummy-id"
  }
  mock_outputs_allowed_terraform_commands = ["validate"]
}

inputs = {
  sg_alb_01_id          = dependency.security-group.outputs.sg_alb_01_id
  sg_alb_01_name        = dependency.security-group.outputs.sg_alb_01_name
  vpc_01_id             = dependency.vpc.outputs.vpc_01_id
  vpc_01_public_subnets = dependency.vpc.outputs.vpc_01_public_subnets
}