variable "region" {}
#variable "availability_zone" {}
variable "instance_type" {}
#variable "vpc-info" {}
variable "vpc-cidr_block" {}
variable "vpc-name" {}
variable "subnet-info" {}
#networking
variable "default-sg-name" {}
#variable "default_sg-info" {}
#variable "default_sg-ingress-info" {}
#variable "default_sg-egress-info" {}
variable "ingress_rules" {}
variable "egress_rules" {}
        # variable "ingress-from_port" {}
        # variable "ingress-protocol" {}
        # variable "ingress-to_port" {}
        # variable "ingress-cidr_block" {}
        # variable "egress-from_port" {}
        # variable "egress-protocol" {}
        # variable "egress-to_port" {}
        # variable "egress-cidr_block" {}


variable "default-rt-name" {}
#variable "rt-routes" {}

#variable "default_rt-info" {}
variable "rt-route-cidr_block" {}
#variable "route_pub-info" {}
# variable "route-route_table_id" {}
# variable "route-destination_cidr_block" {}

#variable "igw-info" {}
variable "igw-name" {}
#variable "nat-subnet_info" {}

# -> EC2
variable "instance-data-most_recent" {}
variable "instance-data-owners" {}
variable "instance-data-filter_name" {}
variable "instance-data-filter_value" {}
#variable "instance_info" {}
variable "private-instance-associate_public_ip_address"{}
variable "public-instance-associate_public_ip_address"{}

#variable "instance-sg"{}
#variable "instance-name"{}

#variable "public_key_location" {}

# $-> ALB
variable "alb_name" {}
variable "alb-target_group_name" {}
variable "alb-target_group_port" {}
variable "alb-target_group_protocol" {}
variable "alb-listener_port" {}
variable "alb-listener_protocol" {}
