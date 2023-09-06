terraform {

  backend "s3" {
    encrypt        = true
    bucket         = "[s3_bucket_name]"
    key            = "[file_name].tfstate"
    region         = "[region_name]"
    profile        = "[your_aws_profile_name]"
    dynamodb_table = "[dynamodb_table_name]"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

locals {
  config_file_name      = "${terraform.workspace}.tfvars"
  full_config_file_path = "variables/${local.config_file_name}"
  vars                  = yamldecode(file(local.full_config_file_path))
}

provider "aws" {
  profile = local.vars.profile
  region  = local.vars.region
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
