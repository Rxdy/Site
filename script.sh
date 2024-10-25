#!/bin/bash
apt update -y
apt install -y apache2
systemctl enable apache2
cd /var/www/html
rm index.html
wget https://raw.githubusercontent.com/Rxdy/Site/refs/heads/main/index.html