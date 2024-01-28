packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "jenkins-ami" {
  ami_name      = "Java-11-Jenkins Linux Builder-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.aws_region
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id
  source_ami_filter {
    filters = {
      name                = var.aws_ami
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["309956199498"]
  }
  ssh_username = "ec2-user"
  tags = {
    "Name"        = "Java-11-Jenkins Linux Builder-${local.timestamp}"
    "Environment" = "Production"
    "OS_Version"  = "RHEL 9"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}