provider "aws" {
  region     = "ap-southeast-2"
}


#Create a new EC2 launch configuration
resource "aws_instance" "ec2_public" {
  count = 1
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = ["${aws_security_group.ssh-security-group.id}"]
  subnet_id                   = aws_subnet.public-subnet-1.id
  associate_public_ip_address = true
  #user_data                   = "${data.template_file.provision.rendered}"
  #iam_instance_profile = "${aws_iam_instance_profile.some_profile.id}"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    "Name" = "EC2-PUBLIC"
  }
  
 
}
#Create a new EC2 launch configuration
resource "aws_instance" "ec2_private" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = ["${aws_security_group.webserver-security-group.id}"]
  subnet_id                   = aws_subnet.private-subnet-1.id
  associate_public_ip_address = false
  #user_data                   = "${data.template_file.provision.rendered}"
  #iam_instance_profile = "${aws_iam_instance_profile.some_profile.id}"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    "Name" = "EC2-PRIVATE"
  }
 
}

terraform {
  backend "s3" {
    bucket = "terraform-aws-state-sandbox"
    key = "poc/services/webserver-cluster/terraform.tfstate"
    region = "ap-southeast-2"
    
    dynamodb_table = "terraform-aws-locks"
    encrypt = true
  }
}
################################
