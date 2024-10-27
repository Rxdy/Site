#!/bin/bash
distrib=$(cat /etc/*release* | grep "^ID=");

if [ $USER != 'root' ]; 
then 
  echo "Erreur ! Attention, vous devez être en root pour lancer le script"; 
  echo "Error ! Please, you must be root to run the script";
  echo $distrib;
else
  if [$distrib == 'ID="rocky"']
  then
    dnf update -y
    dnf install -y httpd
    dnf install -y git
    systemctl enable httpd && systemctl start httpd
    firewall-cmd --add-service=http --permanent
    firewall-cmd --reload
  elif [$distrib == 'ID=debian']
    apt update -y
    apt install -y apache2
    systemctl enable apache2 && systemctl start apache2
    apt install -y git
  fi
  cd /var/www/html
  rm -f index.html
  wget https://raw.githubusercontent.com/Rxdy/Site/refs/heads/main/index.html
  echo "Installation terminée";
fi
