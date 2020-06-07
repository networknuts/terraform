provider "aws" {
  region = "ap-south-1"
}


data "template_file" "web-userdata" {
        template = "${file("install_apache.sh")}"
}

# create first webserver - exampleone

resource "aws_instance" "exampleone" {
  ami                    = "ami-0447a12f28fddb066"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = "${data.template_file.web-userdata.rendered}"
  key_name = "zoomkey"
  tags = {
    Name = "exampleone"
  }
}

#create second webserver - exampletwo
resource "aws_instance" "exampletwo" {
  ami                    = "ami-0447a12f28fddb066"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = "${data.template_file.web-userdata.rendered}"
  key_name = "zoomkey"
  tags = {
    Name = "exampletwo"
  }
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

#creating elastic load balancer
resource "aws_elb" "morning-elb" {
        name = "morning-elb"
        availability_zones = ["ap-south-1a", "ap-south-1b"]
        listener {
                instance_port = 80
                instance_protocol = "http"
                lb_port = 80
                lb_protocol = "http"
        }
        health_check {
                healthy_threshold = 2
                unhealthy_threshold = 2
                timeout = 5
                target = "HTTP:80/"
                interval = 35
        }
        instances = ["${aws_instance.exampleone.id}", "${aws_instance.exampletwo.id}"]
        cross_zone_load_balancing = true
        idle_timeout = 300
        connection_draining = true
        connection_draining_timeout = 300
        tags = {
                Name = "morning-webserver-elb"
        }

}

/*
user data scripe install_apache.sh is in the repository
run
terraform validate
terraform plan
terraform apply
go to aws dashboard check two instances, load balancer
copy the dns name of load balancer, check in browser
the website should be visible.
finally destroy everything using
terraform destroy
*/

