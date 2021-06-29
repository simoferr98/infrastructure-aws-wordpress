locals {
  project_name = get_env("TF_VAR_project_name")
  region       = get_env("TF_VAR_region")
  vpc_azs      = get_env("TF_VAR_vpc_azs")
  account_id   = get_aws_account_id()

  common_tags = {
    "Progetto"  = local.project_name
    "ManagedBy" = "terraform"
  }

}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "skip"
  }
  config = {
    bucket              = "${local.account_id}-${local.project_name}-${local.region}-terraform-state"
    key                 = "${path_relative_to_include()}/terraform.tfstate"
    region              = local.region
    encrypt             = true
    dynamodb_table      = "terraform-state-locks-${local.project_name}"
    dynamodb_table_tags = local.common_tags
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "skip"
  contents  = <<EOF
  provider "aws" {
    region = var.region
  }
EOF
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "skip"
  contents  = <<EOF
  terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.13"
}
EOF
}

inputs = {
  # --
  # variables to be reported in the variables.tf file of each module
  region      = local.region
  account_id  = local.account_id
  vpc_azs     = local.vpc_azs
  common_tags = local.common_tags
  project     = local.project_name
  # --
}