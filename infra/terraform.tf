terraform {
  required_version = "~> 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.64"
    }
  }
}

provider "aws" {
  region = "us-east-1" # one of the cheapest, for the purpose of the demo we do not care about latency
  default_tags {
    tags = {
      ProvisionedBy = "Terraform"
      Product       = "Mtv"
      Owner         = "Chernov"
    }
  }
}
