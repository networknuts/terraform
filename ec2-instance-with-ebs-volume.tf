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

#create block storage
resource "aws_ebs_volume" "data_vol" {
        availability_zone = "ap-south-1a"
        size = 5
}

resource "aws_volume_attachment" "ourfirst-vol" {
        device_name = "/dev/sdc"
        volume_id = "${aws_ebs_volume.data_vol.id}"
        instance_id = "${aws_instance.ourfirst.id}"
}

#block storage end here
resource "aws_instance" "ourfirst" {
  ami           = "ami-0447a12f28fddb066"
  availability_zone = "ap-south-1a"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.webserver_access.name}"]
  key_name = "zoomkey"
  tags = {
    Name  = "hello-terraform"
    Stage = "testing"
    Location = "USA"
  }

}

/*
now run
terraform validate
terraform plan
terraform apply
Then...
ssh into the instance and check the block device
using "lsblk" command
When done ... destroy using
terraform destroy
*/


