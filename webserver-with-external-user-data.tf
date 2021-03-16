provider "aws" {
  region = "ap-south-1"
}


data "template_file" "web-userdata" {
        template = "${file("install_apache.sh")}"
}


resource "aws_instance" "example" {
  ami                    = "ami-0447a12f28fddb066"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = "${data.template_file.web-userdata.rendered}"
  key_name = "zoomkey"
  tags = {
    Name = "terraform-example"
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

#showing the public IP address using output IP

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}

#now create a file "install_apache.sh" with actual code. File is available in repository.
