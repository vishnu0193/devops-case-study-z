## Terraform modules for simple 2 tier architecture


## Assuming 2 tier arch(webservers + database )

Terraform modules created seperately for

1. Autoscaling groups(ec2)
2. Load balancer
3. VPC & SG & NAT & Subnets
4. AWS RDS

These  modules are called from the respective resources block

Creation order:

1. networking components
2. Asgs & alb
3. DB in a subnet group