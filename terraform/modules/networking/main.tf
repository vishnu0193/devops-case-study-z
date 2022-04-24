resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "web-app"
  }
}

## subnets creation

resource "aws_subnet" "web-app-public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_cidr_block_public_subnet
  availability_zone = "us-east-1a"

  tags = {
    Name = "public"
  }
}


resource "aws_subnet" "web-app-private" {
  count = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_cidr_block_private_subnet[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "private"
  }
  map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "web-app"
  }
}

resource "aws_route_table" "route1" {
  depends_on = [
    aws_internet_gateway.gw
  ]

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "myroutetable1"
  }
}
resource "aws_route_table_association" "route_table_association1" {

  depends_on = [
    aws_subnet.web-app-public,
    aws_route_table.route1
  ]

  subnet_id      = aws_subnet.web-app-public.id
  route_table_id = aws_route_table.route1.id
}

resource "aws_eip" "nat_ip" {
  vpc = true
  depends_on                = [aws_internet_gateway.gw]
}
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.web-app-public.id
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "route2" {

depends_on = [
    aws_nat_gateway.example,
    aws_eip.nat_ip
  ]

vpc_id = aws_vpc.main.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.example.id
    }
}

resource "aws_route_table_association" "route_table_association2" {
count = 2
depends_on = [
    aws_subnet.web-app-private,
    aws_route_table.route2
  ]

subnet_id      = aws_subnet.web-app-private[count.index].id
route_table_id = aws_route_table.route2.id
}

resource "aws_security_group" "app" {
  name        = "webapp-sg"
  description = "Default SG to alllow traffic from the VPC"
  vpc_id      = aws_vpc.main.id
  depends_on = [
    aws_vpc.main
  ]

     ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

}
# storing the vpc & other sg id in ssm param store
resource "aws_ssm_parameter" "vpc_id" {
  name  = "/dev/web-app/vpc-id"
  type  = "String"
  value = aws_vpc.main.id
}

resource "aws_ssm_parameter" "sg_id" {
  name  = "/dev/web-app/sg-id"
  type  = "String"
  value = aws_security_group.app.id
}

resource "aws_ssm_parameter" "subnet_id_private" {
  name  = "/dev/web-app/subnet-id/private"
  type  = "String"
  value = aws_subnet.web-app-private[0].id
}

resource "aws_ssm_parameter" "subnet_id_private2" {
  name  = "/dev/web-app/subnet-id/private1"
  type  = "String"
  value = aws_subnet.web-app-private[1].id
}

resource "aws_ssm_parameter" "subnet_id_public" {
  name  = "/dev/web-app/subnet-id/public"
  type  = "String"
  value = aws_subnet.web-app-public.id
}