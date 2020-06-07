#!/bin/bash
yum install httpd -y
echo "<h1>webserver using terraform" >> /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
