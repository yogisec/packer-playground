packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "my-ubuntu-ami-${local.timestamp}"
  instance_type = "t2.medium"
  region        = "us-east-1"
  vpc_filter {
    filters = {
      "tag:Class" : "build"
    }
  }
  subnet_filter {
      filters = {
          "tag:Class": "build"
      }
  }
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "bootstrap"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "files/setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "shell" {
    script = "files/setup.sh"
  }
}
