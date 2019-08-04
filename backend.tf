# BACKEND Information
terraform {
  backend "s3" {
    bucket                  = "thoughtworks-mayank"
    region                  = "eu-west-2"
    profile                 = "thoughtworks-profile"
    shared_credentials_file = "~/.aws/credentials"
    key                     = "thoughtwork.tfstate"
  }
}

# Location to save terraform tfstate
data "terraform_remote_state" "default" {
  backend = "s3"

  config {
    bucket                  = "thoughtworks-mayank"
    region                  = "eu-west-2"
    profile                 = "thoughtworks-profile"
    shared_credentials_file = "~/.aws/credentials"
    key                     = "thoughtwork.tfstate"
  }
}
