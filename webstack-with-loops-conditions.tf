provider "aws" {
        region = "ap-south-1"
}

variable "environment" {
        default = "production"
}


#security group start here

resource "aws_security_group" "instance" {

  name = var.security_group_name

        ingress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

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
}
#security group end here


variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}


data "template_file" "web-userdata" {
        template = "${file("install_apache.sh")}"
}


resource "aws_instance" "web" {
  ami                    = "ami-0447a12f28fddb066"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = "${data.template_file.web-userdata.rendered}"
  key_name = "zoomkey"
  tags = {
    Name = "web-example"
  }
# condition syntax - condition ? true : false
#  count = 2
  count = "${var.environment == "development" ? 2 : 4}"
}

resource "aws_elb" "web" {
        name = "web-elb"
        availability_zones = ["ap-south-1a", "ap-south-1b"]
        listener {
                instance_port = 80
                instance_protocol = "http"
                lb_port = 80
                lb_protocol = "http"
        }

        instances = "${aws_instance.web.*.id}"
        cross_zone_load_balancing = true

}

#showing output of our stack
output "elb_address" {
        value = "${aws_elb.web.dns_name}"
}

output "addresses" {
        value = ["${aws_instance.web.*.public_ip}"]
}


/*
this will create complete web stack
with elb.
run
terraform validate
terraform plan
terraform apply
note down the elb dns name
go to aws dashboard to confirm all
resources
finally run
terraform destroy
*/
