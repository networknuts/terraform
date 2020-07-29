/* this will create a aws instance and attach a EIP to it
read the steps at the end of the file, carefully
god bless you

You also need to export your AWS KEY and AWS SECRET for
successful execution

export AWS_ACCESS_KEY=<your key>
export AWS_SECRET_ACCESS_KEY=<your secret>

filename - instance-eip.tf

*/

provider "aws" {
  region     = "ap-south-1"
}


resource "aws_instance" "ourfirst" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
}

resource "aws_eip" "ourfirst" {
instance = "${aws_instance.ourfirst.id}"
}

/*
run
# terraform validate
# terraform plan
# terraform apply
You can also use - terraform show, to display created resources
and after checking the instance on aws dashboard
terraform destroy

Saving plan output. Terraform plan allows us to save output to a file
# terraform plan -out myplan-`date +'%s'`.plan

We can create different plan output for every new step added.

This will create a file with timestamp. This file can also be used to
apply.

# terraform apply myplan-date<somevalue>.plan

These plan outputs then become small steps we could apply 
to our infrastructure, incrementally and carefully.

You can use the -target flag on both the terraform
plan and terraform apply commands.

#terraform plan -target aws_eip.ourfirst


*/
