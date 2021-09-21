provider "aws" {
  region="ap-south-1"
}

locals {

  env="${terraform.workspace}"

  counts = {
    "default"=1
    "prod"=3
    "dev"=2
  }

  instances = {
    "default"="t2.micro"
    "prod"="t2.small"
    "dev"="t2.micro"
  }

  tags = {
    "default"="webserver-def"
    "prod"="webserver-prod"
    "dev"="webserver-dev"
  }


  instance_type="${lookup(local.instances,local.env)}"
  count="${lookup(local.counts,local.env)}"
  mytag="${lookup(local.tags,local.env)}"

}


resource "aws_instance" "my_work" {
 ami="ami-0447a12f28fddb066"
 instance_type="${local.instance_type}"
 count="${local.count}"
 tags = {
    Name="${local.mytag}"
 }

}

#Create two workspaces - dev and prod
#terraform workspace new dev
#terraform workspace new prod

#Switch to a workspace
#terraform workspace select <workspace-name>

#List all workspaces
#terraform workspace list

#Delete a workspace
#terraform workspace delete <workspace-name>
#
#The advantage of using locals instead of variables is that locals can have
#logic inside them, instead of in the resource. Whereas variables only allows
#values and push the logic inside the resource.
