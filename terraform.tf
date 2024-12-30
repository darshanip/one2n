provider "aws" {
  region = "us-east-1"
}

# S3 Bucket Resource for storing application data
resource "aws_s3_bucket" "app_data_bucket" {
  bucket        = "one2ndemobucket2"
  force_destroy = true
}

# IAM Role for EC2 Instance to interact with AWS services
resource "aws_iam_role" "ec2_service_role" {
  name               = "app_service_ec2_role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "sts:AssumeRole",
        Principal : {
          Service : "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for S3 Bucket Access
resource "aws_iam_policy" "s3_bucket_access_policy" {
  name        = "s3_bucket_access_policy"
  description = "Policy to allow EC2 instances to access the S3 bucket"
  policy      = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect   : "Allow",
        Action   : ["s3:GetObject","s3:PutObject","s3:ListBucket"],
        Resource : [
          "arn:aws:s3:::one2ndemobucket2",
          "arn:aws:s3:::one2ndemobucket2/*"
        ]
      }
    ]
  })
}

# Attach the S3 Policy to the EC2 Role
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.ec2_service_role.name
  policy_arn = aws_iam_policy.s3_bucket_access_policy.arn
}

# Instance Profile for EC2 Instance with assigned role
resource "aws_iam_instance_profile" "ec2_service_instance_profile" {
  name = "app_service_instance_profile"
  role = aws_iam_role.ec2_service_role.name
}

# Security Group for EC2 Instance to allow HTTP and HTTPS traffic
resource "aws_security_group" "app_service_sg" {
  name        = "app_service_security_group"
  description = "Allow HTTP and HTTPS inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance Resource with startup script and security group
resource "aws_instance" "app_service_instance" {
  ami           = "ami-01816d07b1128cd2d" # Amazon Linux 2023 AMI
  instance_type = "t2.micro"

  # User data for startup script
  user_data = file("startup-script.sh")

  security_groups = [aws_security_group.app_service_sg.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_service_instance_profile.name
  associate_public_ip_address = true
}