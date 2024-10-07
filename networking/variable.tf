variable "vpc_id" {}
variable "default-sg-name" {}
# variable "default_sg-info" {
#     type = map(object({
#         #vpc-id = string
#         ingress-from_port = string
#         ingress-protocol = string
#         ingress-to_port = string
#         ingress-cidr_block = string
#         egress-from_port = string
#         egress-protocol = string
#         egress-to_port = string
#         egress-cidr_block = string
#         #Name = string
#     }))
# }
# variable "default_sg-ingress-info" {
#   type = map(object({
#         ingress-from_port = string
#         ingress-protocol = string
#         ingress-to_port = string
#         ingress-cidr_block = string
#   }))
# }
# variable "default_sg-egress-info" {
#   type = map(object({
#         egress-from_port = string
#         egress-protocol = string
#         egress-to_port = string
#         egress-cidr_block = string
#   }))
# }
        # variable "ingress-from_port" {}
        # variable "ingress-protocol" {}
        # variable "ingress-to_port" {}
        # variable "ingress-cidr_block" {}
        # variable "egress-from_port" {}
        # variable "egress-protocol" {}
        # variable "egress-to_port" {}
        # variable "egress-cidr_block" {}

#variable "vpc-default_route_table_id" {}
#variable "default_route_table_id" {}
variable "rt-route-cidr_block" {}
variable "default-rt-name" {}
# variable "rt-routes" {
#   description = "List of routes to be added to the route table"
#   type = list(object({
#     cidr_block = string
#     gateway_id             = optional(string)
#     nat_gateway_id         = optional(string)
#     # egress_only_gateway_id = optional(string)
#     # transit_gateway_id     = optional(string)
#     # vpc_peering_connection_id = optional(string)
#     # instance_id            = optional(string)
#     # network_interface_id   = optional(string)
#   }))
#   default = []
# }
variable "pub-subnet_ids" {
  description = "List of subnet IDs to associate with the route table"
  type        = list(string)
  default     = []
}
#variable "rt-route-cidr_block" {}
# variable "default_rt-info" {
#     type = map(object({
#         #default_route_table_id = string
#         rt-route-cidr_block = string
#        # igw-id = string
#         #Name = string
#     }))
# }
#variable "igw_id" {}
# variable "route_pub-info" {
#     type = map(object({
#         route_table_id = string
#         destination_cidr_block = string
#         igw-id = string
#     }))
# }
# variable "route-route_table_id" {}
# variable "route-destination_cidr_block" {}
#variable "igw-id" {}

#variable "igw_id" {}
# variable "igw-info" {
#     type = map(object({
#        # vpc_id = string
#         Name = string
#     }))
# }
variable "igw-name" {}
# variable "nat-subnet_info" {
#     description = "List of private subnet IDs."
#     type = list(string)
# }

variable "prv-subnet_ids" {
    #description = "List of NAT subnet IDs."
    type = list(string)
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}