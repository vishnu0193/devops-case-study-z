module "db" {
  source = "../../modules/aws_rds"
  db_instance_name = "webappdb"
  subnet_id_private     =  "/dev/web-app/subnet-id/private"
  subnet_id_private1 = "/dev/web-app/subnet-id/private1"
  db_instance_class = "db.t3.micro"
  db_engine = "mysql"
  db_engine_version = "5.7"
  db_instance_user = "testapp"
}