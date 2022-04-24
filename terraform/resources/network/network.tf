module "vpc_app" {
  source = "../../modules/networking"
  vpc_cidr_block                = "10.0.0.0/16"
  vpc_cidr_block_private_subnet = ["10.0.2.0/24","10.0.3.0/24"]
  vpc_cidr_block_public_subnet  = "10.0.0.0/24"
}