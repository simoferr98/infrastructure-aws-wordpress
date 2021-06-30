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
    sg_efs_01_id   = ["temporary-dummy-id"]
    sg_efs_01_name = ["temporary-dummy-id"]
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

inputs = {
  sg_efs_01_id           = dependency.security-group.outputs.sg_efs_01_id
  sg_efs_01_name         = dependency.security-group.outputs.sg_efs_01_name
  vpc_01_private_subnets = dependency.vpc.outputs.vpc_01_private_subnets
}