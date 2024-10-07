# resource "aws_vpc" "vpc" {
#   for_each = var.vpc-info
#   cidr_block = each.value.cidr_block
#   tags = {
#     Name = each.value.Name
#   }
# }
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.name
  }
}