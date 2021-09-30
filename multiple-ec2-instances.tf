provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "my-instance" {
  count         = var.instance_count
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.instance_type
  key_name      = "zoomkey"

  tags = {
    Name  = "Terraform-${count.index + 1}"
    Batch = "5AM"
  }
}


variable "ami" {
  type = map

  default = {
    "us-east-1" = "ami-087c17d1fe0178315"
    "ap-south-1" = "ami-0a23ccb2cdd9286bb"
  }
}

variable "instance_count" {
  default = "2"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "aws_region" {
  default = "ap-south-1"
}
