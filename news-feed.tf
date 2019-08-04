# Create the role for the access
resource "aws_iam_role" "newsfeed_backend_role" {
  name               = "${var.newsfeed_role}_role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_document.json}"
}

# Create EC2 Instance profile to avoid creation of default EC2
resource "aws_iam_instance_profile" "newsfeed_instance_profile" {
  name = "${var.newsfeed_role}_instance_profile"
  role = "${var.newsfeed_role}_role"
}

# Create Security Group for news-feed
resource "aws_security_group" "newsfeed_sg" {
  name        = "${var.newsfeed_role}_sg"
  description = "SG for ${var.newsfeed_role} app"

  # Access to newsfeed port
  ingress {
    from_port   = "${var.newsfeed_app_port}"
    to_port     = "${var.newsfeed_app_port}"
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

# Create a launch configuration for newsfeed server
resource "aws_launch_configuration" "newsfeed_lc" {
  name                 = "${var.newsfeed_role}-asg-lc"
  image_id             = "${data.aws_ami.newsfeed_aws_amis.id}"
  instance_type        = "${var.newsfeed_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.newsfeed_instance_profile.name}"
  security_groups      = ["${aws_security_group.newsfeed_sg.id}"]
  key_name             = "${var.key_name}"
}

# Create an Auto Scaling Group with launch configuration
resource "aws_autoscaling_group" "newsfeed_asg" {
  availability_zones   = ["${data.aws_availability_zones.available.names}"]
  name                 = "${var.newsfeed_role}-asg"
  max_size             = "${var.newsfeed_asg_max}"
  min_size             = "${var.newsfeed_asg_min}"
  desired_capacity     = "${var.newsfeed_asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.newsfeed_lc.name}"
  target_group_arns    = ["${aws_alb_target_group.newsfeed_internal.arn}"]

  tag {
    key                 = "Name"
    value               = "${var.newsfeed_role}-Server"
    propagate_at_launch = "true"
  }
}

# Create S3 IAM Access policy
resource "aws_iam_policy" "newsfeed_policy" {
  name   = "${var.newsfeed_role}_policy"
  policy = "${data.aws_iam_policy_document.s3access.json}"
}

resource "aws_iam_role_policy_attachment" "newsfeed_attach-policy-to-role" {
  role       = "${aws_iam_role.newsfeed_backend_role.name}"
  policy_arn = "${aws_iam_policy.newsfeed_policy.arn}"
}

# Create Application Load Balancer for newsfeed server
resource "aws_lb" "newsfeed_alb" {
  name                       = "${var.newsfeed_role}-alb"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = ["${aws_security_group.newsfeed_sg.id}"]
  enable_deletion_protection = false
  subnets                    = ["${data.aws_subnet.default.*.id}"]

  tags = {
    Environment = "${var.environment}"
  }
}

# Create Health check for ALB target
resource "aws_alb_target_group" "newsfeed_internal" {
  name                 = "${var.newsfeed_role}-target-group"
  port                 = "${var.newsfeed_app_port}"
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

resource "aws_lb_listener" "newsfeed_http" {
  load_balancer_arn = "${aws_lb.newsfeed_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.newsfeed_internal.arn}"
  }
}

# Create CNMAE for newsfeed url assuming thoughtworks is having hosted zone
# mayankkumar <ZoneID: Z8IUA1JEKXHIM>  :D
resource "aws_route53_record" "newsfeed_url" {
  zone_id = "${var.zone_id}"
  name    = "newsfeed"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.newsfeed_alb.dns_name}"]
}
