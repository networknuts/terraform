/* this will create a aws instance and attach a EIP to it
the AMI's are choosen based on the region in which instance 
is running. In our case, if the region is:
 INDIA - Amazon Linux AMI
 USA - SuSE Linux AMI

Variables must be defined in a separate file, lets call it
variables.tf in the current directory, with these contents:

---- variables.tf

variable "region" {
	description = "AWS region to build resources"
	default = "ap-south-1"
}



variable "ami" {
	type = "map"
	default = {
# this is a amazon linux ami
		ap-south-1 = "ami-0b5bff6d9495eff69"
# this is a suse linux ami
		us-east-1 = "ami-095d73d5068ebbc22"
	}
	description = "AMI to use"
}


---- file ends here

You also need to export your AWS KEY and AWS SECRET for
successful execution

export AWS_ACCESS_KEY=<your key>
export AWS_SECRET_ACCESS_KEY=<your secret>

------ Now create main file - instance-eip-variables.tf

*/

provider "aws" {
  region     = "${var.region}"
}


resource "aws_instance" "ourfirst" {
  ami           = "${lookup(var.ami, var.region)}"
#here we are calling a function - lookup, the syntax is
# "${lookup(map, key)}"
# so it will lookup to var.ami variable based on var.region
  instance_type = "t2.micro"
}

resource "aws_eip" "ourfirst" {
instance = "${aws_instance.ourfirst.id}"
}

/*
run
# terraform validate
# terraform plan
# "check the value of ami" based on region
# now change the region to us-east-1 and run terraform plan again
# "check the value of ami" again

# terraform apply
You can also use - terraform show, to display created resources
and after checking the instance on aws dashboard
terraform destroy


*/
