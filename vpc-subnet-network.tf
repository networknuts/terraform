provider "aws" {
	region = "ap-south-1"
}

#variables 

variable "vpc_cidr" {
	default = "10.1.0.0/16"
	description = "cidr for our custom vpc"
}

variable "subnet_cidr" {
	default = "10.1.1.0/24"
	description = "cidr for subnet"
}

variable "availability_zone" {
	default = "ap-south-1a"
	description = "AZ for subnet"
}

variable "instance_ami" {
	default = "ami-0b5bff6d9495eff69"
	description = "default ami for instances"
}

variable "instance_type" {
	default = "t2.micro"
	description = "instance type for ec2"
}

variable "env_tag" {
	default = "production"
	description = "environment tag"
}


# code - creating vpc

resource "aws_vpc" "vpcone" {
	cidr_block = "${var.vpc_cidr}"
	tags = {
		Name = "${var.env_tag}"
	}
}

# code - creating IG and attaching it to VPC

resource "aws_internet_gateway" "vpcone-ig" {
	vpc_id = "${aws_vpc.vpcone.id}"
	tags = {
		Name = "${var.env_tag}"
	}
}

# code - create subnet inside our vpc

resource "aws_subnet" "subnet_public" {
	vpc_id = "${aws_vpc.vpcone.id}"
	cidr_block = "${var.subnet_cidr}"
	map_public_ip_on_launch = "true"
	availability_zone = "${var.availability_zone}"
	tags = {
		Name = "${var.env_tag}"
	}

}

# code - modifying route 

resource "aws_route_table" "rtb_public" {
	vpc_id = "${aws_vpc.vpcone.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.vpcone-ig.id}"
	}
	tags = {
		Name = "${var.env_tag}"
	}
}


# code - attaching subnets to route table

resource "aws_route_table_association" "rta_subnet_public" {
	subnet_id = "${aws_subnet.subnet_public.id}"
	route_table_id = "${aws_route_table.rtb_public.id}"
}


# code - create security group

resource "aws_security_group" "sg_newvpc" {
	name = "newvpc"
	vpc_id = "${aws_vpc.vpcone.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "${var.env_tag}"
	}

}


# code - create instance

resource "aws_instance" "test" {
	ami = "${var.instance_ami}"
	instance_type = "${var.instance_type}"
	subnet_id = "${aws_subnet.subnet_public.id}"
	vpc_security_group_ids = ["${aws_security_group.sg_newvpc.id}"]
	tags = {
		Name = "${var.env_tag}"
	}
}

