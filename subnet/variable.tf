variable "vpc_id" {}
variable "subnet-info" {
  type = map(object({
        #vpc-id = string
        cidr_block = string
        availability_zone = string
        map_public_ip_on_launch = bool
        Name = string
    }))
}