terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "first_file" {
  filename = "hello-terraform.txt"
  content  = "Hello from Terraform. This file was created using Infrastructure as Code."
}
