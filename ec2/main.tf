# resource "aws_instance" "ec2" {
  
#   #eypair
#   tags = {
#     Name = var.name
#   }
# }
data "aws_ami" "ami" {
  most_recent = var.data-most_recent
  owners      = [var.data-owners]
  filter {
    name   = var.data-filter_name
    values = [var.data-filter_value]
  }
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ami.id
  # for_each = var.isntance-info
  count    = length(var.instance-subnet_ids)
  subnet_id                   = var.instance-subnet_ids[count.index]
  instance_type               = var.instance-type
  ##key_name                   = aws_key_pair.ssh-key.key_name
  #availability_zone           = each.value.instance-a_z
  security_groups             = [var.instance-sg]
  associate_public_ip_address = var.instance-associate_public_ip_address
  tags = {
    #Name = var.instance-name
    Name = "${var.instance-name}-${count.index + 1}"
  }
  #key_name = aws_key_pair.ssh-key.key_name
  key_name = var.key_name
  #user_data = file("filedestination") -> locate file.sh script
  #write script directrly here 
    # user_data = <<-EOF
    #                   #!/bin/bash

    #               EOF

  #user_data = var.instance-associate_public_ip_address ? var.jump_server-user_data : var.machine-user_data 
}


# resource "aws_key_pair" "ssh-key" {
#   count = 1
#   key_name   = "ec2-key-pair"
#   public_key = file("./ec2-key-pair.pub") #locate ec2 public key, you can use ~/.ssh/id_rsa
# }
