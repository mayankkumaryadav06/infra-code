variable "aws_region" {
  default = "eu-west-2"
}

#SSH Key pair to login
variable "key_name" {
  default     = "ThoughtWorksKey"
  description = "Name of AWS key pair"
}

# Route53 zone ID reference
variable "zone_id" {
  default = "Z8IUA1JEKXHIM"
}

# Default cide block. Shouldnt be open for internet
variable "cidr_blocks" {
  description = "Public CIDR block"
  default     = ["0.0.0.0/0"]
}

# Default environment
variable "environment" {
  default = "Prod"
}

# AWS Credentials file location
variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

# AWS Profile name where state profile is kept
variable "aws_state_profile" {
  default = "thoughtworks-profile"
}

# AWS Profile name where resource profile is kept
variable "aws_resource_profile" {
  default = "thoughtworks-profile"
}

########################################
# Variables for Frontend Server
########################################
variable "frontend_role" {
  default = "front-end"
}

variable "frontend_asg_max" {
  description = "Max couunt of instance in ASG for frontend"
  default     = 3
}

variable "frontend_asg_min" {
  description = "Min couunt of instance in ASG for frontend"
  default     = 1
}

variable "frontend_asg_desired" {
  description = "Desriable couunt of instance in ASG for frontend"
  default     = 1
}

variable "frontend_app_port" {
  default = 8081
}

# Started with ami id but updated it use data filter
# variable "frontend_aws_amis" {
#   default = {
#     "eu-west-2" = "ami-0d8e27447ec2c8410"
#   }
# }

variable "frontend_instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "frontend_version" {
  default     = "20190803-2105"
  description = "AMI Version for front-end"
}

########################################
# Variables for News Feed Server
########################################

variable "newsfeed_role" {
  default = "news-feed"
}

variable "newsfeed_asg_max" {
  description = "Max couunt of instance in ASG for newsfeed"
  default     = 3
}

variable "newsfeed_asg_min" {
  description = "Min couunt of instance in ASG for newsfeed"
  default     = 1
}

variable "newsfeed_asg_desired" {
  description = "Desriable couunt of instance in ASG for newsfeed"
  default     = 1
}

variable "newsfeed_app_port" {
  default = 8082
}

variable "newsfeed_version" {
  default     = "20190803-2105"
  description = "AMI Version for news-feed"
}

# Started with ami id but updated it use data filter
# variable "newsfeed_aws_amis" {
#   default = {
#     "eu-west-2" = "ami-0d8e27447ec2c8410"
#   }
# }

variable "newsfeed_instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

########################################
# Variables for Quotes Feed Server
########################################

variable "quotesfeed_role" {
  default = "quotes-feed"
}

variable "quotesfeed_asg_max" {
  description = "Max couunt of instance in ASG for quotesfeed"
  default     = 3
}

variable "quotesfeed_asg_min" {
  description = "Min couunt of instance in ASG for quotesfeed"
  default     = 1
}

variable "quotesfeed_asg_desired" {
  description = "Desriable couunt of instance in ASG for quotesfeed"
  default     = 1
}

variable "quotesfeed_app_port" {
  default = 8080
}

# Started with ami id but updated it use data filter
# variable "quotesfeed_aws_amis" {
#   default = {
#     "eu-west-2" = "ami-0d8e27447ec2c8410"
#   }
# }

variable "quotesfeed_instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "quotesfeed_version" {
  default     = "20190803-2105"
  description = "AMI Version for quotes-feed"
}
