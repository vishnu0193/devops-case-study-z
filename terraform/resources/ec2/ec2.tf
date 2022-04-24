module "asg" {
  source = "../../modules/aws_asg"

  instance_type = "t2.micro"
  key_name      = "devops"
  max           = "2"
  min           = "2"
  sg_id_param   = "/dev/web-app/sg-id"
  vpc_id_param  = "/dev/web-app/vpc-id"
  subnet_id_private     =  "/dev/web-app/subnet-id/private"
  subnet_id_public = "/dev/web-app/subnet-id/public"
}

module "lb" {
  source = "../../modules/aws_alb"
  sg_id_param       = "/dev/web-app/sg-id"
  subnet_id_private = "/dev/web-app/subnet-id/private"
  vpc_id_param      = "/dev/web-app/vpc-id"
  subnet_id_public  = "/dev/web-app/subnet-id/public"
}


resource "aws_alb_target_group_attachment" "attach_ec2" {
  count = 2
  target_group_arn = module.lb.target_arn
  target_id        = module.asg.private_instance_ids_webapp[count.index]
}