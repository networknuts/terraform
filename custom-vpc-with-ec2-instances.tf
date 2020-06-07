provider "aws" {
	region = "ap-south-1"
}

resource "aws_vpc" "vpc_by_terra" {
	cidr_block = "10.0.0.0/16"
	tags = {
		Name = "vpc_by_terra"
	}
}

resource "aws_subnet" "sub_one" {
	vpc_id = "${aws_vpc.vpc_by_terra.id}"
	cidr_block = "10.0.1.0/24"
	tags = {
		Name = "subone"
	}
}

resource "aws_instance" "serverone" {
	ami = "ami-5b673c34"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.sub_one.id}"
}

resource "aws_instance" "servertwo" {
	ami = "ami-5b673c34"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.sub_one.id}"
	depends_on = ["aws_instance.serverone"]
	count = 2

}


/*
run 
terraform validate
terraform plan
terraform apply
check your vpc and three instances inside
custom vpc
check with graph also
terraform graph | dot -Tpng -o graph.png
check the relationship between resources
*/
