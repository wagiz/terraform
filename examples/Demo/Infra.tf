provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sample" {
  ami                    = "ami-0dc863062bc04e1de"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_sample.id, "sg-0bcf4abee87c39a2d"]

  tags = {
    Name = "sample"
  }
}

resource "aws_security_group" "allow_sample" {
  name        = "allow_sample"
  description = "Allow sample traffic"

  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 1521
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "allow_sample"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-wagiz"
    key    = "terraform-wagiz/key"
    region = "us-east-1"
  }
}

{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": "s3:ListBucket",
"Resource": "arn:aws:s3:::terraform-wagiz"
},
{
"Effect": "Allow",
"Action": ["s3:GetObject", "s3:PutObject"],
"Resource": "arn:aws:s3:::terraform-wagiz/key"
}
]
}

terraform {
  backend "s3" {
    bucket = "terraform-wagiz"
    key    = "example/sample/terraform.tfstate"
    region = "us-east-1"
  }
}