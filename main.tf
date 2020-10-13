terraform {
  required_version = ">= 0.12.19"
}

# ---------------------------------------------------------------------------------------------------------------------
# PREPARE PROVIDERS
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  version = "~> 3.0"
  region  = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A TFSTATE-BACKEND
# ---------------------------------------------------------------------------------------------------------------------
module "tfstate-backend" {
  source  = "cloudposse/tfstate-backend/aws"
  version = "0.25.0"

  namespace     = var.codebuild_name
  stage         = var.environment
  name          = var.codebuild_name
  force_destroy = true

  attributes = ["terraform", "state"]

  tags = {
    managed_by  = "Terraform"
    project     = "OS Image Build"
    environment = var.environment
  }
}

module "codebuild_project" {
  source = "./modules/codebuild-project"

  # Required variable inputs - those without defaults
  # See module for additional variable inputs to change as necessary
  repository_name = var.repository_name
  codebuild_name  = var.codebuild_name
}

# Populate CodeCommit with initial repository
locals {
  git_clone_url = module.codebuild_project.git_clone_http
  code_dir      = "${path.module}/packer/"
}
resource "null_resource" "bootstrap_codecommit" {
  provisioner "local-exec" {
    command = <<EOF
      cd ${local.code_dir};
      git init; 
      git add .;
      git commit -m "Bootstrap Master";
      git remote add origin ${local.git_clone_url};
      git remote set-url origin ${local.git_clone_url};
      git push origin master;
    EOF
  }
  depends_on = [module.codebuild_project]

}

# Secrets Manager
module "secrets-manager" {
  source = "./modules/secrets-manager"
}