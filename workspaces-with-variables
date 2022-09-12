# Create directories - mkdir -p ~/myworkspaces/environments
# Create file "main.tf" inside "myworkspaces" directory with these contents
### vim ~/myworkspaces/main.tf

terraform {
  backend "s3" {
    region = "ap-south-1"
    bucket = "networknuts-terra-states"  #you can create your own S3 bucket
    key = "state.tfstate"
    encrypt = true    #AES-256 encryption
  }
}

# create terraform workspaces
# terraform workspace new prod
# terraform workspace new dev


variable "region" {
   description = "aws region to create resources"
   type = string
}


provider "aws" {
  region = var.region
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


  myami = {
    "prod"="ami-06489866022e12a14"    #india ami
    "dev"="ami-05fa00d4c63e32376"     #usa ami
  }

  instance_type="${lookup(local.instances,local.env)}"
  count="${lookup(local.counts,local.env)}"
  mytag="${lookup(local.tags,local.env)}"
  ami="${lookup(local.myami,local.env)}"

}
##

resource "aws_instance" "my_work" {
 ami="${local.ami}"
 instance_type="${local.instance_type}"
 count="${local.count}"
 tags = {
    Name="${local.mytag}"
 }

}

### main.tf ends here

##### NOW create two files dev.tfvars and prod.tfvars

# vim ~/myworkspaces/environments/dev.tfvars
     region = "us-east-1"
# vim ~/myworkspaces/environments/prod.tfvars
     region = "ap-south-1"
    
#### select dev workspace and apply 
# terraform workspace select dev
# terraform apply --var-file=./environments/dev.tfvars -auto-approve

### select prod workspace and apply
# terraform workspace select prod
# terraform apply --var-file=./environments/prod.tfvars -auto-approve

### Delete everything
# terraform workspace select dev
# terraform destroy -var-file=environments/dev.tfvars -auto-approve

# terraform workspace select prod
# terraform destroy -var-file=environments/prod.tfvars -auto-approve
