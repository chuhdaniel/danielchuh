# variables.pkr.hcl

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_ami" {
  type    = string
  default = "RHEL-9.2.0_HVM-20230503-x86_64-41-Hourly2-GP2"
}

variable "subnet_id" {
  type    = string
  default = "subnet-05fcd8141723e50a4"
}

variable "vpc_id" {
  type    = string
  default = "vpc-076dd208a87dca238"
}