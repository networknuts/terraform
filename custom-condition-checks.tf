provider "aws" {
  region = "ap-south-1" #mumbai region
}

data "aws_ami" "example" {
  owners = ["amazon"]
  filter {
    name   = "image-id"
    values = ["ami-019774e5caffd1685"] #this is a arm architecture ami
  }
}

resource "aws_instance" "example" {
  ami = data.aws_ami.example.id
  instance_type = "t2.micro"
  lifecycle {
    precondition {
      condition     = data.aws_ami.example.architecture == "x86_64"
      error_message = "The selected AMI must be for the x86_64 architecture."
    }
  }
  tags = {
     Name = "india-server"
   }
}
