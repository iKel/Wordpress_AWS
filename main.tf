module "my_vpc" {           
  source = "./modules/VPC"  
}

module "wordpress" {
  source = "./modules/Wordpress"
  vpc_id = module.my_vpc.vpc_id 
  key = module.my_vpc.key_pem
  wordpess_subnet = module.my_vpc.public_sub_3
  rds_subnet = [module.my_vpc.private_sub_0, module.my_vpc.private_sub_1, module.my_vpc.private_sub_2]  
}

output "wordpress_public_ip" {    # Prints public_dns for easy access
  value = module.wordpress.public_dns
}
