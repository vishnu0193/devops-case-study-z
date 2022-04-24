resource "random_password" "db_secret" {
  length = 16
  special          = true
}

data "aws_ssm_parameter" "subnet_id_private" {
  name = var.subnet_id_private
}

data "aws_ssm_parameter" "subnet_id_private1" {
  name = var.subnet_id_private1
}

resource "aws_db_subnet_group" "web-app" {
  name       = "webapp-subnet-group"
  subnet_ids = [data.aws_ssm_parameter.subnet_id_private.value,data.aws_ssm_parameter.subnet_id_private1.value]

  tags = {
    Name = "web-app subnet group"
  }
}
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  name                 = var.db_instance_name
  username             = var.db_instance_user
  password             = random_password.db_secret.result
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.web-app.name
}