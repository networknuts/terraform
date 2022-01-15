# filename - variables.tf
variable "ami" {
	default = "ami-0447a12f28fddb066"
	description = "AMI to use"
	sensitive = true
}

#file end here
/*
now create one more file that will 
use the variables, call it base.tf
with these contents
*/

# filename - base.tf
provider "aws" {
	region = "ap-south-1"

}

resource "aws_instance" "base" {
	ami = var.ami
	instance_type = "t2.micro"
}

/*
put both the files in a single directory
then run
terraform validate
terraform plan
terraform apply
*/



