
provider "aws" {
  region     = "ap-south-1"
}

#security group
resource "aws_security_group" "webserver_access" {
        name = "webserver_access"
        description = "allow ssh and http"

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


resource "aws_instance" "ourfirst" {
  ami           = "ami-0447a12f28fddb066"
  availability_zone = "ap-south-1a"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.webserver_access.name}"]
  tags = {
    Name  = "hello-terraform"
    Stage = "testing"
    Location = "USA"
  }

}


/*
run
terraform validate
terraform plan
terraform apply
check ec2 instance on aws dashboard
then destroy using
terraform destroy
*/



