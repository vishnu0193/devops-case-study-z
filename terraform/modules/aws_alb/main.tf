
data "aws_ssm_parameter" "vpc_id" {
  name = var.vpc_id_param
}

data "aws_ssm_parameter" "sg_id" {
  name = var.sg_id_param
}

data "aws_ssm_parameter" "subnet_id_private" {
  name = var.subnet_id_private
}

data "aws_ssm_parameter" "subnet_id_public" {
  name = var.subnet_id_public
}
resource "aws_lb" "web-app" {
  name               = "web-app"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.sg_id.value]
  subnets            = [data.aws_ssm_parameter.subnet_id_private.value,data.aws_ssm_parameter.subnet_id_public.value]

  enable_deletion_protection = false


  tags = {
    Environment = "test"
  }

}
resource "aws_lb_target_group" "app" {
  name     = "web-app-tf"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web-app.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

