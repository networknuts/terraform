provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "ec2-instance" {
#    ami = "ami-041d6256ed0f2061c"    # this AMI is specific to Mumbai region
    ami = var.ami_id    # referring to ami_id variable
#    instance_type = "t2.micro"
    instance_type = var.instance_type  # referring to instance_type variable
    vpc_security_group_ids = [aws_security_group.mysg.id]
}

resource "aws_security_group" "mysg" {
    name = "allow-ssh"
    description = "Allow ssh traffic"
#    vpc_id = "vpc-3345b25a"   # VPC ID of my account's default vpc
    vpc_id = var.vpc_id   # referring to vpc_id variable

    ingress {
        description = "Allow inbound ssh traffic"
#        from_port = 22
        from_port = var.port
#        to_port = 22
        to_port = var.port
        protocol = "tcp"
#        cidr_blocks = "[0.0.0.0/0]"
        cidr_blocks = [var.cidr_block]
    }

    tags = {
        name = "allow_ssh"
    }
}
