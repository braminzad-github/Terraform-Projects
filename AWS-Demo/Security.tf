### Security Groups
resource "aws_security_group" "br_sg" {
  name        = "br_sg"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.BR_VPC.id
  tags = {
    Name = "BR_Deloitte_Demo_SG"
  }
# Alloww HTTP access
  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
# Allow SSH/SCP access
  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  
}

#### 
# resource "aws_network_interface_sg_attachment" "sg_attachment" {
#   security_group_id    = aws_security_group.BR_sg.id
#   network_interface_id = aws_instance.BR_instance1.primary_network_interface_id
# }
