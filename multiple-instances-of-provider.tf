provider "aws" {
  region = "ap-south-1" #mumbai region
}

provider "aws" {
   region = "us-east-1" #virginia region
   alias = "usa"
}

resource "aws_instance" "indiaserver" {
  ami = "ami-0c1a7f89451184c8b" #this ami is specific to mumbai region
  instance_type = "t2.micro"
  tags = {
     Name = "india-server"
   }
}

resource "aws_instance" "usaserver {
  ami = "ami-02e136e904f3da870"   #this ami is specific to virginia region
  instance_type = "t2.micro"
  provider = aws.usa
  tags = {
     Name = "usa-server"
  }
}

 
