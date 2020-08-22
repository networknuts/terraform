# First create ssh keys in current directory using
# ssh-keygen -f terraform_ec2_key
# This will create two files in current directory
# 1. terraform_ec2_key
# 2. terraform_ec2_key.pub

# Now create instance which will use these keys
### vim instance-with-ssh-keys.tf ####

provider "aws" {
  region     = "ap-south-1"
}


resource "aws_instance" "myfirst" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  key_name = "terraform_ec2_key"
}

resource "aws_key_pair" "terraform_ec2_key" {
	key_name = "terraform_ec2_key"
	public_key = "${file("terraform_ec2_key.pub")}"
}

#### file ends here ####
# terraform validate
# terraform plan
# terraform apply
# Once the ec2 instance is created, go to aws dashboard
# copy the ssh command (remove .pem) 
# ssh -i "terraform_ec2_key" ec2-user@your-ip-address
# 
# finally destroy everything
# terraform destroy
