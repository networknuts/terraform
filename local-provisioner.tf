provider "aws" {
  region = "ap-south-1" #mumbai region
}

resource "aws_instance" "sampleserver" {
  ami = "ami-0c1a7f89451184c8b" #this ami is specific to mumbai region
  instance_type = "t2.micro"
  tags = {
     Name = "local-provisioner"
  }

#this will run at creation
  provisioner "local-exec" {
     command = "echo Server IP address is ${self.private_ip}"
  }

#this will run at destroy
  provisioner "local-exec" {
     when = destroy
     command = "echo Server is destroyed"
  }
}
