#!/bin/bash
if [ $USER != 'root' ]; 
then 
  echo "Vous devez être en root pour lancer le script"; 
else
dnf update -y
dnf install -y httpd
systemctl enable httpd && systemctl start httpd
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
cd /var/www/html
rm index.html
wget https://raw.githubusercontent.com/Rxdy/Site/refs/heads/main/index.html

echo "Installation terminée";
fi
