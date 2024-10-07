module "VPC-M" {
    source = "./VPC"
    cidr_block = var.vpc-cidr_block
    name = var.vpc-name
}
module "SUBNET-M" {
    source = "./SUBNET"
   # vpc_id = module.VPC.vpc_id
    vpc_id = module.VPC-M.vpc-out.id
    subnet-info = var.subnet-info
}
module "NETWORKING-M" {
    source = "./NETWORKING"
    vpc_id = module.VPC-M.vpc-out.id
    default-sg-name = var.default-sg-name
    ingress_rules = var.ingress_rules
    egress_rules = var.egress_rules
    #default_sg-info = var.default_sg-info
        # ingress-cidr_block = var.ingress-cidr_block
        # ingress-from_port = var.ingress-from_port
        # ingress-protocol = var.ingress-protocol
        # ingress-to_port = var.ingress-to_port
        # egress-cidr_block = var.egress-cidr_block
        # egress-from_port = var.egress-from_port
        # egress-protocol = var.egress-protocol
        # egress-to_port = var.egress-to_port

    #default_route_table_id = module.VPC-M.vpc-out.default_route_table_id
    #rt-routes = var.rt-routes
    default-rt-name = var.default-rt-name
    rt-route-cidr_block = var.rt-route-cidr_block
    #igw_id = module.NETWORKING.igw-out.id
    # route-route_table_id = var.route-route_table_id
    # route-destination_cidr_block = var.route-destination_cidr_block
    #igw-info = var.igw-info
    igw-name = var.igw-name
    #nat-subnet_info = module.SUBNET.private-subnet-ids-ec2
    prv-subnet_ids = module.SUBNET-M.private-subnet-ids-ec2
    pub-subnet_ids = module.SUBNET-M.public-subnet-ids-lb
}
module "key_pair" {
  source     = "./KEY-PAIR"
  key_name   = "my-key-pair"
  public_key = file("./my-key-pair.pub") # Path to your public key file
}
module "private-EC2-M" { #ec2 instances
    source = "./EC2"
    data-most_recent = var.instance-data-most_recent
    data-owners = var.instance-data-owners
    data-filter_name = var.instance-data-filter_name
    data-filter_value = var.instance-data-filter_value
    #isntance-info = var.instance_info
    instance-subnet_ids = module.SUBNET-M.private-subnet-ids-ec2
    instance-type = var.instance_type
    instance-sg = module.NETWORKING-M.sg-out.id
    instance-associate_public_ip_address = var.private-instance-associate_public_ip_address
    instance-name = "private-ec2"
    #user_data = instance-associate_public_ip_address ? var.jump_server-user_data : var.machine-user_data
    key_name = module.key_pair.key_name
    #public_key_location = var.public_key_location
}
module "public-EC2-M" { #$$$$$$$$$$ jump server
    source = "./EC2" 
    data-most_recent = var.instance-data-most_recent
    data-owners = var.instance-data-owners
    data-filter_name = var.instance-data-filter_name
    data-filter_value = var.instance-data-filter_value
    #isntance-info = var.instance_info
    instance-subnet_ids = [module.SUBNET-M.public-subnet-ids-lb[0]]
    instance-type = var.instance_type
    instance-sg = module.NETWORKING-M.sg-out.id
    instance-associate_public_ip_address = var.public-instance-associate_public_ip_address
    instance-name = "public-ec2"
    key_name = module.key_pair.key_name
    #public_key_location = var.public_key_location
}
module "ALB" {
  source = "./ALB"
  alb_name = var.alb_name
  security_groups = [module.NETWORKING-M.sg-out.id]
  subnets = module.SUBNET-M.public-subnet-ids-lb
  #tags = #var.alb_tags
  target_group_name = var.alb-target_group_name
  target_group_port = var.alb-target_group_port
  target_group_protocol = var.alb-target_group_protocol
  target_group_vpc_id = module.VPC-M.vpc-out.id
  ec2_instance_ids = module.private-EC2-M.ec2_ids
  listener_port = var.alb-listener_port
  listener_protocol = var.alb-listener_protocol
}