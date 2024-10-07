# resource "aws_default_security_group" "default-sg" {    # -> trying to make this block dynamic 
#     vpc_id = var.vpc_id
#     #vpc_id = each.value.vpc-id
#     tags = {
#     Name = var.default-sg-name
#     }
#     # for_each = var.default_sg-info
#     # ingress {
#     # from_port   = each.value.ingress-from_port
#     # protocol    = each.value.ingress-protocol
#     # to_port     = each.value.ingress-to_port
#     # cidr_blocks = [each.value.ingress-cidr_block]
#     # }
#     # egress {
#     # from_port   = each.value.egress-from_port
#     # protocol    = each.value.egress-protocol
#     # to_port     = each.value.egress-to_port
#     # cidr_blocks = [each.value.egress-cidr_block]
#     # }\
#     ingress {
#     from_port   = var.ingress-from_port #need to test list [var]
#     protocol    = var.ingress-protocol
#     to_port     = var.ingress-to_port
#     cidr_blocks = [var.ingress-cidr_block]
#     }
#     egress {
#     from_port   = var.egress-from_port
#     protocol    = var.egress-protocol
#     to_port     = var.egress-to_port
#     cidr_blocks = [var.egress-cidr_block]
#     }
# }

resource "aws_security_group" "sg" {
    vpc_id = var.vpc_id
    #vpc_id = each.value.vpc-id
    tags = {
    Name = var.default-sg-name
    }
    dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
    dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

# resource "aws_default_route_table" "default-routetable" { # -> trying to make this block dynamic 
#   #default_route_table_id = var.vpc-default_route_table_id
#   default_route_table_id = var.default_route_table_id
#   #for_each = var.default_rt-info
#   route {
#     cidr_block = var.rt-route-cidr_block
#     gateway_id = aws_internet_gateway.igw.id
#     nat_gateway_id = aws_nat_gateway.nat[0].id
#   }
#   route {
#     cidr_block = var.rt-route-cidr_block
#     gateway_id = aws_internet_gateway.igw.id
#     nat_gateway_id = aws_nat_gateway.nat[1].id
#   }
#   tags = {
#     Name = var.default-rt-name
#   }
# }
resource "aws_route_table" "public_routetable" {  #make rt for private to nat, public to igw 
  vpc_id = var.vpc_id
  # dynamic "route" {
  #   for_each = var.rt-routes
  #   content {
  #     cidr_block = route.value.cidr_block
  #     gateway_id             = aws_internet_gateway.igw.id
  #     nat_gateway_id         = lookup(route.value, "nat_gateway_id", null)
  #     # egress_only_gateway_id = lookup(route.value, "egress_only_gateway_id", null)
  #     # transit_gateway_id     = lookup(route.value, "transit_gateway_id", null)
  #     # vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
  #     # instance_id            = lookup(route.value, "instance_id", null)
  #     # network_interface_id   = lookup(route.value, "network_interface_id", null)
  #   }
  # }
  #count          = length(var.subnet_ids)
  #count = length(var.pub-subnet_ids) #can be deleted 
  route {
    cidr_block = var.rt-route-cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_routetable"
  }
}
resource "aws_route_table" "private_routetable" {  #make rt for private to nat, public to igw 
  vpc_id = var.vpc_id
  count = length(var.prv-subnet_ids)
  route {
    cidr_block = var.rt-route-cidr_block
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  #  dynamic "route" {
  #   for_each = aws_nat_gateway.nat
  #   content {
  #     cidr_block = var.rt-route-cidr_block
  #     nat_gateway_id         = route.value.id
  #   }
  # }
  tags = {
    Name = "private_routetable"
  }
}
resource "aws_route_table_association" "public_dynamic_association" {
  count          = length(var.pub-subnet_ids)
  subnet_id      = var.pub-subnet_ids[count.index]
  route_table_id = aws_route_table.public_routetable.id
}
resource "aws_route_table_association" "private_dynamic_association" {
  count          = length(var.prv-subnet_ids)
  subnet_id      = var.prv-subnet_ids[count.index]
  route_table_id = aws_route_table.private_routetable[count.index].id
}
# resource "aws_route" "route_pub" {
#   #for_each = var.route_pub-info
#   # route_table_id         = each.value.route_table_id
#   # destination_cidr_block = each.value.destination_cidr_block
#   # gateway_id             = each.value.igw-id
#   route_table_id         = var.route-route_table_id
#   destination_cidr_block = var.route-destination_cidr_block
#   gateway_id             = var.igw_id
# }
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  #for_each = var.igw-info
  tags = {
  Name = var.igw-name
  }
}

# resource "aws_nat_gateway" "nat" { #-> making this block dynamic
#   # count = 2
#   # subnet_id = element([var.nat-subnet_ids], count.index)
#   #-> allocation_id = aws_eip.example.id
#   #allocation_id = aws_eip.eip[count.index].id
#   allocation_id = aws_eip.eip[count.index].id
#   #count    = length(var.nat-subnet_info)
#   #for_each = toset(var.nat-subnet_info)
#   #subnet_id = var.nat-subnet_info[count.index]
#   #secondary_private_ip_addresses = [  ]
#   #for_each = toset(var.nat-subnet_ids)
#   count = length(var.nat-subnet_ids)
#   subnet_id = var.nat-subnet_ids[count.index]
#   # Name = each.value.Name
#   # }
#   depends_on = [aws_eip.eip]
# }
# resource "aws_eip" "eip" { #-> making this block dynamic
#     #domain = "vpc"
#     count = 2 #needs modification to be dynamic
#     depends_on = [aws_internet_gateway.igw]
# }
resource "aws_nat_gateway" "nat" {
  count = length(var.pub-subnet_ids)

  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = var.pub-subnet_ids[count.index]
  connectivity_type = "public"

  tags = {
     Name = "nat-gateway-${count.index + 1}" 
  }
  depends_on = [ aws_eip.eip ]
}
resource "aws_eip" "eip" {
  count = length(var.prv-subnet_ids)
  #domain = "vpc"
  tags = {Name = "nat-eip-${count.index + 1}" }
}