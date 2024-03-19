terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "4.66.1"
      configuration_aliases = [aws.alternate]
    }
  }

  backend "s3" {
    bucket = "sbc-demo-tfstate-s3"
    key    = "terraform/orbika/tfstate"
    region = "us-east-1"
  }
}

