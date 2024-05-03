variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {
    type = list(string)
}
variable "avail_zone" {
    type = list(string)
}
variable "tags_prefix" {}
variable "default_route" {}
variable "my_ip" {}
variable "instance_type" {
    type = list(string)
}
