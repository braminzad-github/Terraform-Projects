### Creating VPC
resource "aws_vpc" "BR_VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "BR-VPC-DeloitteTF-Demo"
  }
}

### Create Public Subnets
resource "aws_subnet" "BR_Subnet1" {
  vpc_id            = aws_vpc.BR_VPC.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Deloitte_Demo_Subnet1"
  }
}
resource "aws_subnet" "BR_Subnet2" {
  vpc_id            = aws_vpc.BR_VPC.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = "ap-southeast-2b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Deloitte_Demo_Subnet2"
  }
}