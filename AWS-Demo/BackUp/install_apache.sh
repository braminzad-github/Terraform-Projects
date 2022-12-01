#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
suod service httpd start
sudo yum install -y httpd mariadb-server php-mbstring php-xml
sudo systemctl start httpd
sudo systemctl enable httpd
sudo usermod -a -G apache ec2-user
sudo hown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
sudo find /var/www -type d -exec sudo chmod 2775 {} \;
sudo find /var/www -type f -exec sudo chmod 0664 {} \;
#IP_ADDRESS=$(ifconfig eth0 | grep inet)
IP_ADDRESS=$(uname -a)
echo "<h1>Deloitte's Terraform Demo</h1> This Server Details:   $IP_ADDRESS" | sudo tee /var/www/html/index.html