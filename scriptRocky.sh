#!/bin/bash

dnf update -y
dnf install -y httpd
systemctl enable httpd && systemctl start httpd
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
cd /var/www/html
rm index.html
wget https://raw.githubusercontent.com/Rxdy/Site/refs/heads/main/index.html
