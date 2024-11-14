terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "meredith_deploy_playground" {
  instance_type     = "t2.micro"
  ami               = data.aws_ami.ubuntu.id
  availability_zone = "us-east-2b"

  monitoring      = false
  security_groups = ["allow-all-outbound-traffic", "restrict-inbound-http-https-to-vpc-network", "allow-all-inbound-ssh-traffic"]
  key_name        = "meredith-deploy-playground-web-server"

  tags = {
    Name = "meredith-deploy-playground"
  }
}
