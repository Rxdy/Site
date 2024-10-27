#!/bin/bash
if [ $USER != 'root' ]; 
then 
  echo "Vous devez être en root pour lancer le script"; 
else
  apt update -y
  apt install -y apache2
  systemctl enable apache2
  cd /var/www/html
  rm index.html
  wget https://raw.githubusercontent.com/Rxdy/Site/refs/heads/main/index.html
fi
