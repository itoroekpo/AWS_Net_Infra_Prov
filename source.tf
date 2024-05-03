resource "aws_vpc" "master-class-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.tags_prefix}-vpc"
    }
}

module "master-class-subnet" {
    source = "./modules/subnets"
    avail_zone = var.avail_zone
    subnet_cidr_block = var.subnet_cidr_block
    tags_prefix = var.tags_prefix
    vpc_id = aws_vpc.master-class-vpc.id
    default_route = var.default_route
    default_route_table_id = aws_vpc.master-class-vpc.default_route_table_id
}

module "master-class-server" {
    source = "./modules/webserver"
    vpc_id = aws_vpc.master-class-vpc.id
    subnet_id = module.master-class-subnet.master-class-sub-2.id
    my_ip = var.my_ip
    avail_zone = var.avail_zone
    default_route = var.default_route
    tags_prefix = var.tags_prefix
    instance_type = var.instance_type
}
