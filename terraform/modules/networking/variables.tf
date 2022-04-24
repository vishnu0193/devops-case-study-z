variable "vpc_cidr_block" {
  type = string

}

variable "vpc_cidr_block_public_subnet" {
    type = string

}
#variable "subnet_id" {
#  type = list(string)
#
#}

variable "vpc_cidr_block_private_subnet" {
    type = list(string)

}
variable "availability_zones" {
  type = list(string)
  default = ["us-east-1a","us-east-1b"]
}