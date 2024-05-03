resource "aws_subnet" "master-class-sub-1" {
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block[0]
    availability_zone = var.avail_zone[0]
    map_public_ip_on_launch = true
    tags = {
        Name: "${var.tags_prefix}-sub-1"
    }
}

resource "aws_subnet" "master-class-sub-2" {
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block[1]
    availability_zone = var.avail_zone[1]
    map_public_ip_on_launch = true
    tags = {
        Name: "${var.tags_prefix}-sub-2"
    }
}

resource "aws_route_table" "master-class-rt" {
    vpc_id = var.vpc_id
    tags = {
        Name: "${var.tags_prefix}-rtb"
    }
}

resource "aws_default_route_table" "master-class-main-rt" {
    default_route_table_id = var.default_route_table_id
    tags = {
        Name: "${var.tags_prefix}-main_rtb"
    }
}

resource "aws_route_table_association" "class-sub-1-rtb" {
    subnet_id = aws_subnet.master-class-sub-1.id
    route_table_id = aws_default_route_table.master-class-main-rt.id
}

resource "aws_route_table_association" "class-sub-2-rtb" {
    subnet_id = aws_subnet.master-class-sub-2.id
    route_table_id = aws_route_table.master-class-rt.id
}

resource "aws_internet_gateway" "master-class-igw" {
    vpc_id = var.vpc_id
    tags = {
      Name: "${var.tags_prefix}-igw"
    }
}

resource "aws_eip" "eip-nat-gw" {
    depends_on = [ aws_internet_gateway.master-class-igw ]
    tags = {
      Name: "${var.tags_prefix}-nat-eip"
    }
}

resource "aws_nat_gateway" "master-class-nat-gw" {
    allocation_id = aws_eip.eip-nat-gw.id
    subnet_id = aws_subnet.master-class-sub-2.id
    tags = {
      Name: "${var.tags_prefix}-nat-gw"
    }

    depends_on = [ aws_internet_gateway.master-class-igw ]
}

resource "aws_route" "master-class-main-nat-gw" {
    route_table_id = aws_default_route_table.master-class-main-rt.id
    destination_cidr_block = var.default_route
    nat_gateway_id = aws_nat_gateway.master-class-nat-gw.id
}

resource "aws_route" "master-class-custom-igw" {
    route_table_id = aws_route_table.master-class-rt.id
    destination_cidr_block = var.default_route
    gateway_id = aws_internet_gateway.master-class-igw.id
}
