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

resource "aws_instance" "spot_deploy_playground" {
  instance_type     = "c7i-flex.large"
  ami               = "ami-0884d2865dbe9de4b"
  availability_zone = "us-east-2b"

  monitoring      = false
  security_groups = ["allow-all-outbound-traffic", "restrict-inbound-http-https-to-vpc-network", "allow-all-inbound-ssh-traffic"]
  key_name        = "meredith-deploy-playground-web-server"

  tags = {
    Name = "spot-deploy-playground"
  }
}

resource "aws_lb" "meredith_deploy_playground" {
  name               = "meredith-deploy-playground"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0d324a71da2676332", "sg-0d5993757572fb9c3", "sg-0f2660631f08705c3"]
  subnets            = ["subnet-e5e953a9", "subnet-3dd78447", "subnet-eb04e180"]

  enable_http2                                = false
  enable_tls_version_and_cipher_suite_headers = true
  enable_waf_fail_open                        = true

  enable_deletion_protection = false
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.meredith_deploy_playground.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.http_https_traffic.arn
        weight = 1
      }
      stickiness {
        duration = 3600
        enabled  = false
      }
    }
    target_group_arn = aws_lb_target_group.http_https_traffic.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.meredith_deploy_playground.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.meredith_deploy_playground.arn

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.http_https_traffic.arn
        weight = 1
      }
      stickiness {
        duration = 3600
        enabled  = false
      }
    }
    target_group_arn = aws_lb_target_group.http_https_traffic.arn
  }
}

resource "aws_lb_target_group" "http_https_traffic" {
  name     = "meredith-deploy-playground"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.meredith_deploy_playground.id
}

resource "aws_lb_target_group_attachment" "http" {
  target_group_arn = aws_lb_target_group.http_https_traffic.arn
  target_id        = aws_instance.spot_deploy_playground.id
  port             = 80
}

resource "aws_vpc" "meredith_deploy_playground" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_acm_certificate" "meredith_deploy_playground" {
  domain_name       = "meredith-deploy-playground.co"
  validation_method = "DNS"
}

resource "aws_route53_zone" "meredith_deploy_playground" {
  name          = "meredith-deploy-playground.co"
  comment       = "Managed by Terraform"
  force_destroy = false
}

resource "aws_route53_record" "meredith_deploy_playground" {
  zone_id = aws_route53_zone.meredith_deploy_playground.zone_id
  name    = "meredith-deploy-playground.co"
  type    = "A"

  alias {
    evaluate_target_health = true
    name                   = aws_lb.meredith_deploy_playground.dns_name
    zone_id                = aws_lb.meredith_deploy_playground.zone_id
  }
}

resource "aws_route53_record" "www_meredith_deploy_playground" {
  zone_id = aws_route53_zone.meredith_deploy_playground.zone_id
  name    = "www.meredith-deploy-playground.co"
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = "meredith-deploy-playground.co"
    zone_id                = aws_route53_zone.meredith_deploy_playground.zone_id
  }
}
