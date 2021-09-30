## Create a file - instances.tf
###
provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "my-instance" {
  count         = var.instance_count
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.instance_type
  key_name      = "zoomkey"

  tags = {
    Name  = element(var.instance_tags, count.index)
    env = "test"
  }
}

## File end here

## Create another file - vars.tf
###
variable "ami" {
  type = map

  default = {
    "us-east-1" = "ami-04169656fea786776"
    "ap-south-1" = "ami-006fce2a9625b177f"
  }
}

variable "instance_count" {
  default = "2"
}

variable "instance_tags" {
  type = list
  default = ["Terraform-1", "Terraform-2"]
}

variable "instance_type" {
  default = "t2.nano"
}

variable "aws_region" {
  default = "ap-south-1"
}

# File end here
