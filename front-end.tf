# Create the role for the access
resource "aws_iam_role" "access_frontend_role" {
  name               = "${var.frontend_role}_role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_document.json}"
}

# Create EC2 Instance profile to avoid creation of default EC2
resource "aws_iam_instance_profile" "frontend_instance_profile" {
  name = "${var.frontend_role}_instance_profile"
  role = "${var.frontend_role}_role"
}

# Create Security Group for Front-end
resource "aws_security_group" "frontend_sg" {
  name        = "${var.frontend_role}_sg"
  description = "${var.frontend_role} SG"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Access to frontend port
  ingress {
    from_port   = "${var.frontend_app_port}"
    to_port     = "${var.frontend_app_port}"
    protocol    = "tcp"
    cidr_blocks = "${var.cidr_blocks}"
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a launch configuration for frontend servers
resource "aws_launch_configuration" "frontend_lc" {
  name                 = "${var.frontend_role}-asg-lc"
  image_id             = "${data.aws_ami.frontend_aws_amis.id}"
  instance_type        = "${var.frontend_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.frontend_instance_profile.name}"
  security_groups      = ["${aws_security_group.frontend_sg.id}"]
  key_name             = "${var.key_name}"
}

# Create an Auto Scaling Group with launch configuration
resource "aws_autoscaling_group" "frontend_asg" {
  availability_zones   = ["${data.aws_availability_zones.available.names}"]
  name                 = "${var.frontend_role}-asg"
  max_size             = "${var.frontend_asg_max}"
  min_size             = "${var.frontend_asg_min}"
  desired_capacity     = "${var.frontend_asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.frontend_lc.name}"
  target_group_arns    = ["${aws_alb_target_group.frontend_internal.arn}"]

  tag {
    key                 = "Name"
    value               = "${var.frontend_role}-Server"
    propagate_at_launch = "true"
  }
}

# Create S3 IAM Access policy
resource "aws_iam_policy" "frontend_policy" {
  name   = "${var.frontend_role}_policy"
  policy = "${data.aws_iam_policy_document.s3access.json}"
}

resource "aws_iam_role_policy_attachment" "frontend_attach-policy-to-role" {
  role       = "${aws_iam_role.access_frontend_role.name}"
  policy_arn = "${aws_iam_policy.frontend_policy.arn}"
}

# Create Application Load Balancer for frontend server
resource "aws_lb" "frontend_alb" {
  name                       = "${var.frontend_role}-alb"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = ["${aws_security_group.frontend_sg.id}"]
  enable_deletion_protection = false
  subnets                    = ["${data.aws_subnet.default.*.id}"]

  tags = {
    Environment = "${var.environment}"
  }
}

# Create Health check for ALB target
resource "aws_alb_target_group" "frontend_internal" {
  name                 = "${var.frontend_role}-target-group"
  port                 = "${var.frontend_app_port}"
  protocol             = "HTTP"
  vpc_id               = "${aws_default_vpc.default.id}"
  deregistration_delay = 60

  health_check {
    interval            = 5
    path                = "/ping"
    protocol            = "HTTP"
    timeout             = 2
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299,403"
  }
}

resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = "${aws_lb.frontend_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.frontend_internal.arn}"
  }
}

#Setup Egress rule from Frontend for newsfeed
resource "aws_security_group_rule" "egress_frontend_to_newsfeed" {
  type                     = "egress"
  from_port                = "8082"
  to_port                  = "8082"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.frontend_sg.id}"
  source_security_group_id = "${aws_security_group.newsfeed_sg.id}"
}

#Setup Egress rule from Frontend for quotesfeed
resource "aws_security_group_rule" "egress_frontend_to_quotes" {
  type                     = "egress"
  from_port                = "8080"
  to_port                  = "8080"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.frontend_sg.id}"
  source_security_group_id = "${aws_security_group.quotesfeed_sg.id}"
}
