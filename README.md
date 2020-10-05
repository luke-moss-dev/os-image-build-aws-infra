# Initialize the AWS Developer Tools 

This repository contains **Terraform** scripts and other materials that will be used to create an AWS CodeCommit git repository and an accompanying AWS CodeBuild Project -- with the initial goal of hosting an OS Golden Image Builder using the **Packer** tool.


# Files

The root of the project contains a **`main.tf`** and **`variables.tf`** file which imports a local module for creating the infrastructure of the project. Soon, there will be additional files and directions to populate the git repository with the initial codebase for the CodeBuild to work from.