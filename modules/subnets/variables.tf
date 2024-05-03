variable "subnet_cidr_block" {
    type = list(string)
}
variable "avail_zone" {
    type = list(string)
}
variable "tags_prefix" {}
variable "default_route" {}
variable "vpc_id" {}
variable "default_route_table_id" {}