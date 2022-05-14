terraform {
  required_version = "~> 1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.14"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.19"
    }
  }

  backend "s3" {
    bucket               = "jsj-terraform-state"
    key                  = "terraform.tfstate"
    workspace_key_prefix = "alsherz-standards"
    region               = "eu-west-2"
    dynamodb_table       = "terraform-state-lock"
    role_arn             = "arn:aws:iam::247940857651:role/terraform-state-access-alsherz-standards"
  }
}
