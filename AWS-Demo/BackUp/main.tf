provider "aws" {
    region = "ap-southeast-2"
    #profile = "default"
    # assume_role {
    # role_arn = "arn:aws:iam::172264037239:role/DDevOpsCrossAccountAdmin"
    # }
    #user_arn = "arn:aws:iam::946231429173:user/braminzad@deloitte.com.au"
    #role_arn = "arn:aws:iam::141700011076:role/LabRole"
    access_key = "AKIAZE34QLKIKDO4BA7T"
    secret_key = "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"

    
}

# Create a VPC
resource "aws_vpc" "BR_VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "BR-VPC-DeloitteTF-Demo"
  }
}

### Subnet
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

### IGW
resource "aws_internet_gateway" "BR_igw" {
  vpc_id = aws_vpc.BR_VPC.id

  tags = {
    Name = "Deloitte_Demo_IGW"
  }
}

resource "aws_route" "r" {
  route_table_id            = aws_vpc.BR_VPC.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.BR_igw.id
}

/*
### IGW attachement
resource "aws_internet_gateway_attachment" "BR_igw_attachement" {
  internet_gateway_id = aws_internet_gateway.BR_igw.id
  vpc_id              = aws_vpc.BR_VPC.id
}
*/

### Security Group
resource "aws_security_group" "br_sg" {
  name        = "br_sg"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.BR_VPC.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

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

#### Create EC2 Instance 
resource "aws_instance" "BR_instance1" {
    ami = "ami-0d6fb2916ee0ab9fe"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.BR_Subnet1.id
    associate_public_ip_address = true
    key_name = "BR-Key-ap"
    #security_groups = [aws_security_group.br_sg.name]
    vpc_security_group_ids = ["${aws_security_group.br_sg.id}"]


  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = ""
    private_key = file("/Users/braminzad/Downloads/BR-Key-ap.pem")
    host     = self.public_ip
    
  }

   provisioner "file" {
    source      = "install_apache.sh"
    destination = "/tmp/install_apache.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_apache.sh",
      "/tmp/install_apache.sh",
    ]
  }
}

resource "aws_instance" "BR_instance2" {
    ami = "ami-0d6fb2916ee0ab9fe"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.BR_Subnet2.id
    associate_public_ip_address = true
    key_name = "BR-Key-ap"
    #security_groups = [aws_security_group.br_sg.name]
    vpc_security_group_ids = ["${aws_security_group.br_sg.id}"]


  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = ""
    private_key = file("/Users/braminzad/Downloads/BR-Key-ap.pem")
    host     = self.public_ip
    
  }

   provisioner "file" {
    source      = "install_apache.sh"
    destination = "/tmp/install_apache.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_apache.sh",
      "/tmp/install_apache.sh",
    ]
  }
}



##### ELB
# resource "aws_alb" "BR_elb" {
#   name               = "BR-alb"
#   #availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]

#   # listener {
#   #   instance_port     = 80
#   #   instance_protocol = "http"
#   #   lb_port           = 80
#   #   lb_protocol       = "http"
#   # }

#   # health_check {
#   #   healthy_threshold   = 2
#   #   unhealthy_threshold = 2
#   #   timeout             = 3
#   #   target              = "HTTP:80/"
#   #   interval            = 30
#   # }

  
#   internal           = false
#   load_balancer_type = "application"
#   #instances                   = [aws_instance.BR_instance1.id, aws_instance.BR_instance2.id]
#   subnets = [aws_subnet.BR_Subnet1.id, aws_subnet.BR_Subnet2.id]
#   security_groups = ["${aws_security_group.br_sg.id}"]

#   #cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   #connection_draining         = true
#   #connection_draining_timeout = 400

#   tags = {
#     Name = "BR-alb"
#   }
# }

resource "aws_alb" "BR_alb" {  
  name            = "BR-alb"  
  subnets         = [aws_subnet.BR_Subnet1.id, aws_subnet.BR_Subnet2.id]
  security_groups = ["${aws_security_group.br_sg.id}"]
  internal        = false
  idle_timeout    = 400  
  
  
}

resource "aws_alb_listener" "BR_alb_listener" {  
  load_balancer_arn = "${aws_alb.BR_alb.arn}"  
  port              = 80  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_alb_target_group.BR_alb_target_group.arn}"
    type             = "forward"  
  }
}

resource "aws_alb_listener_rule" "BR_listener_rule" {
  depends_on   = [aws_alb_target_group.BR_alb_target_group]  
  listener_arn = "${aws_alb_listener.BR_alb_listener.arn}"  
  priority     = 10   
  action {    
    type             = "forward"    
    target_group_arn = "${aws_alb_target_group.BR_alb_target_group.id}"  
  }   
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_alb_target_group" "BR_alb_target_group" {  
  name     = "BR-alb-tg"  
  port     = 80 
  protocol = "HTTP"  
  vpc_id   = aws_vpc.BR_VPC.id  
  

  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10      
    port                = 80
  }
}


resource "aws_alb_target_group_attachment" "BR_alb_group_attach1" {
  target_group_arn = "${aws_alb_target_group.BR_alb_target_group.arn}"
  target_id        = "${aws_instance.BR_instance1.id}"
  port             = 80
}

resource "aws_alb_target_group_attachment" "BR_alb_group_attach2" {
  target_group_arn = "${aws_alb_target_group.BR_alb_target_group.arn}"
  target_id        = "${aws_instance.BR_instance2.id}"
  port             = 80
}