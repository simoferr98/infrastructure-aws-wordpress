include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../efs"
  ]
}

dependency "efs" {
  config_path = "../efs"
  mock_outputs = {
    efs_01_arn = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["validate"]
}

inputs = {
  efs_01_arn = dependency.efs.outputs.efs_01_arn

}