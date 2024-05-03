variable "avail_zone" {
    type = list(string)
}
variable "tags_prefix" {}
variable "default_route" {}
variable "my_ip" {}
variable "instance_type" {
    type = list(string)
}
variable "subnet_id" {}
variable "vpc_id" {}