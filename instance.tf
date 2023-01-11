provider "aws" {
  region ="us-east-1"
}


resource "aws_instance" "web" {
  count         = "${var.ec2_count}"
  ami           = "${var.ami_id}"
  subnet_id     = "${var.subnet_id}"
  instance_type = "${var.instance_type}"

  tags = {
    Name = "terraform123-ec2"
  }
}

