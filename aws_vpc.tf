provider "aws" {
  region = "ap-south-1"
}
# creating VPC,name,CIDR blocks and tages
resource "aws_vpc" "tf-vpc" {
cidr_block = "10.0.0.0/16"
instance_tenancy = "default"

tags = {
  "Name" = "first_vpc1"
}
}

# Creating Private,Public Subnet in Vpc
resource "aws_subnet" "PubSub-1" {
    vpc_id = aws_vpc.tf-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"

    tags = {
      "Name" = "PublicSubnet"
    }
}
resource "aws_subnet" "PvtSub-1" {
    vpc_id = aws_vpc.tf-vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1b"

    tags = {
      "Name" = "PrivatSubnet"
    }
}

# Creating Internet Gateway in Aws VPC
resource "aws_internet_gateway" "tf-ig" {
    vpc_id = aws_vpc.tf-vpc.id

    tags = {
      "Name" = "first-ig"
    }
  
}
# Creating Rout Tables 

resource "aws_route_table" "pubRou-1" {
    vpc_id = aws_vpc.tf-vpc.id
     route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tf-ig.id
    }
    tags = {
        "Name" = "pubRoute_table"
    }
    }  
     
resource "aws_route_table" "pvtRou-2" {
    vpc_id = aws_vpc.tf-vpc.id
    tags = {
        "Name" = "pvtbRoute_table"
    }
    } 
 # creating Subnet Association to route table

resource "aws_route_table_association" "tf-pubSub-1" {
  subnet_id = aws_subnet.PubSub-1.id
  route_table_id = aws_route_table.pubRou-1.id
}
resource "aws_route_table_association" "tf-pvtSub-1" {
  subnet_id = aws_subnet.PvtSub-1.id
  route_table_id = aws_route_table.pvtRou-2.id
}

# creating security group 
resource "aws_security_group" "tf-sg" {
    name = "security group using terraform"
    description = "security group using terraform"
    vpc_id = aws_vpc.tf-vpc.id

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
     ingress {
        description = "All traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
     ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    egress {
        description = "All traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
      "Name" = "tf-sg"
    }
}

resource "aws_instance" "pub_instance-1" {  
    ami = "ami-0cca134ec43cf708f"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.PubSub-1.id
    key_name = "key11"
    vpc_security_group_ids = ["${aws_security_group.tf-sg.id}"]

    tags = {
      "Name" = "TF-pub-instance"
    }
  
}