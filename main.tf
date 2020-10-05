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
  code_dir      = "${path.module}/RHEL7-AMI-Code"
}
resource "null_resource" "bootstrap_codecommit" {
  provisioner "local-exec" {
    command = <<EOF
      git clone ${local.git_clone_url};
      cd ${var.repository_name};
      cp -r ${local.code_dir} .;
      git commit -a -m "Bootstrap Master";
      git push -u origin master
    EOF
  }
  depends_on = [module.codebuild_project]

}