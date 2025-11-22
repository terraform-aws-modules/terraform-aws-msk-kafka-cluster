terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.22.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}
