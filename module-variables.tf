variable "ami_id" {
    default = "ami-041d6256ed0f2061c"  #AMI ID specific to Mumbai Region
}

variable "instance_type" {
    default = "t2.micro"
}

variable "vpc_id" {
    default = "vpc-3345b25a"    #VPC ID of my account's default vpc
}

variable "port" {
    default = 22
}

variable "cidr_block" {
    default = "0.0.0.0/0"
}
