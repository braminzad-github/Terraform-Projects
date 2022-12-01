#### Create EC2 Instances
resource "aws_instance" "BR_instance1" {
    ami = "ami-0d6fb2916ee0ab9fe"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.BR_Subnet1.id
    associate_public_ip_address = true
    key_name = "BR-Key-ap"
    #security_groups = [aws_security_group.br_sg.name]
    vpc_security_group_ids = ["${aws_security_group.br_sg.id}"]

    tags = {
    Name = "BR_Deloitte_Demo_Instance1"
    }

  # Connecting to the instance via SSH
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = ""
    private_key = file("/Users/braminzad/Downloads/BR-Key-ap.pem")
    host     = self.public_ip
    
  }

  # Copying shell sript file into the newly created instance
  provisioner "file" {
    source      = "install_apache.sh"
    destination = "/tmp/install_apache.sh"
  }
 
  # Executing the shell scrip file
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

    tags = {
    Name = "BR_Deloitte_Demo_Instance2"
    }

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

