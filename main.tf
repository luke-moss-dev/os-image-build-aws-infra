provider "aws" {
  region = var.region
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
      git remote set-url origin ${local.git_clone_url};
      git push origin master;
    EOF
  }
  depends_on = [module.codebuild_project]

}