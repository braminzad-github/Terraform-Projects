### Creating Internet Gateway Resource
resource "aws_internet_gateway" "BR_igw" {
  vpc_id = aws_vpc.BR_VPC.id

  tags = {
    Name = "Deloitte_Demo_IGW"
  }
}

### Add a default route for internet access. This route is added to the VPC's default route table.
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

### Creating Applicatin Load Balancer
resource "aws_alb" "BR_alb" {  
  name            = "BR-alb"  
  subnets         = [aws_subnet.BR_Subnet1.id, aws_subnet.BR_Subnet2.id]
  security_groups = ["${aws_security_group.br_sg.id}"]
  internal        = false
  idle_timeout    = 400  
  
}

### Creating ALB listener
resource "aws_alb_listener" "BR_alb_listener" {  
  load_balancer_arn = "${aws_alb.BR_alb.arn}"  
  port              = 80  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_alb_target_group.BR_alb_target_group.arn}"
    type             = "forward"  
  }
}

### Cerating listerner rule to forward http traffic to the target group
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

### Create ALB target group
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

### Attaching Target Grout to instace1
resource "aws_alb_target_group_attachment" "BR_alb_group_attach1" {
  target_group_arn = "${aws_alb_target_group.BR_alb_target_group.arn}"
  target_id        = "${aws_instance.BR_instance1.id}"
  port             = 80
}

### Attaching Target Group to instance2
resource "aws_alb_target_group_attachment" "BR_alb_group_attach2" {
  target_group_arn = "${aws_alb_target_group.BR_alb_target_group.arn}"
  target_id        = "${aws_instance.BR_instance2.id}"
  port             = 80
}

output "alb_dns_name" {
  value = aws_alb.BR_alb.dns_name
}