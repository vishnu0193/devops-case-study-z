data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
data "aws_ssm_parameter" "vpc_id" {
  name = var.vpc_id_param
}

data "aws_ssm_parameter" "sg_id" {
  name = var.sg_id_param
}

data "aws_ssm_parameter" "private_subnet_id" {
  name = var.subnet_id_private
}

data "aws_ssm_parameter" "public_subnet_id" {
  name = var.subnet_id_public
}
resource "aws_launch_configuration" "web_server" {
  name_prefix   = "webapp-launch-config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [data.aws_ssm_parameter.sg_id.value]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_server_groups" {
  name                 = "web-app-servers"
  launch_configuration = aws_launch_configuration.web_server.name
  min_size             = var.min
  max_size             = var.max
  vpc_zone_identifier = [data.aws_ssm_parameter.private_subnet_id.value,data.aws_ssm_parameter.public_subnet_id.value]

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "web-app-ec2"
    propagate_at_launch = true
  }

}

data "aws_instances" "webapp-ec2" {
  filter {
    name   = "tag:Name"
    values = ["web-app-ec2"]
  }
  depends_on = [aws_autoscaling_group.web_server_groups]
}