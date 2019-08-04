#Search the ami matching filter. Name: Thoughtworks-<app-name> and Version: <AMI-Version>
# Version contains git commit id so to know AMI is created against which commit
data "aws_ami" "frontend_aws_amis" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["Thoughtworks-frontend-*"]
  }

  filter {
    name   = "tag:Version"
    values = ["${var.frontend_version}-*"]
  }
}

data "aws_ami" "newsfeed_aws_amis" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["Thoughtworks-newsfeed-*"]
  }

  filter {
    name   = "tag:Version"
    values = ["${var.newsfeed_version}-*"]
  }
}

data "aws_ami" "quotesfeed_aws_amis" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["Thoughtworks-quotesfeed-*"]
  }

  filter {
    name   = "tag:Version"
    values = ["${var.quotesfeed_version}-*"]
  }
}
