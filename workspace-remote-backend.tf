# make sure the aws s3 bucket exist


# changing backend to s3

terraform {
  backend "s3" {
    region = "ap-south-1"
    bucket = "networknuts-terra-states"
    key = "state.tfstate"
    encrypt = true    #AES-256 encryption
  }
}

# create terraform workspaces
# terraform workspace new prod
# terraform workspace new dev


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
## 

resource "aws_instance" "my_work" {
 ami="ami-0447a12f28fddb066"
 instance_type="${local.instance_type}"
 count="${local.count}"
 tags = {
    Name="${local.mytag}"
 }

}
