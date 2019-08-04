# PROVIDERS
provider "aws" {
  profile                 = "${var.aws_resource_profile}"
  shared_credentials_file = "${var.shared_credentials_file}"
  region                  = "${var.aws_region}"
}

# Get details of availability_zone
data "aws_availability_zones" "available" {}

# Data
data "terraform_remote_state" "infra" {
  backend = "s3"

  "config" {
    bucket                  = "thoughtworks-mayank"
    key                     = "infra.tfstate"
    region                  = "${var.aws_region}"
    profile                 = "${var.aws_state_profile}"
    shared_credentials_file = "${var.shared_credentials_file}"
  }
}

# Create the policy for IAM to access EC2
data "aws_iam_policy_document" "assume_role_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create Default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Get details of default vpc subnet ID
data "aws_subnet_ids" "default" {
  vpc_id = "${aws_default_vpc.default.id}"
}

# Details of subnet instance
data "aws_subnet" "default" {
  count = 3
  id    = "${data.aws_subnet_ids.default.ids[count.index]}"
}

# Create S3 Access policy document where tfstate will be stored
data "aws_iam_policy_document" "s3access" {
  statement {
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    resources = ["arn:aws:s3:::thoughtworks-mayank/*",
      "arn:aws:s3:::thoughtworks-mayank/",
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:eu-west-2:*:parameter/newsfeed_token"]
  }
}
