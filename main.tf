#  ---root/main.tf---

module "networking" {
  source         = "./modules/networking"
  vpc_cidr       = "192.168.0.0/16"
  public_subnet  = "192.168.2.0/24"
  public_subnet2 = "192.168.4.0/24"
}

module "compute" {
  source            = "./modules/compute"
  user_data         = file("userdata.tpl")
  security_group_id = module.networking.security_group_id
  public_subnet_id  = module.networking.public_subnet_id
}

module "loadbalancer" {
  source            = "./modules/loadbalancer"
  public_subnet_id  = module.networking.public_subnet_id
  public_subnet_id2 = module.networking.public_subnet_id2
  security_group_id = module.networking.security_group_id
  vpc_id            = module.networking.vpc_id
  instance_id       = module.compute.ec2_ids
}


module "route53" {
  source                = "./modules/route53"
  loadbalancer_dns_name = module.loadbalancer.loadbalancer_dns_name
  loadbalancer_zone_id  = module.loadbalancer.loadbalancer_zone_id

}