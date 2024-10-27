#!/bin/bash
distrib=$(cat /etc/issue | grep "Debian");
if [ $USER != 'root' ]; 
then 
  echo "Erreur ! Attention, vous devez être en root pour lancer le script"; 
  echo "Error ! Please, you must be root to run the script"; 
  echo $distrib;
else
  if [$distrib == null];
  then
    

  else
    apt update -y
    apt install -y apache2
    systemctl enable apache2
    cd /var/www/html
    rm index.html
    wget https://raw.githubusercontent.com/Rxdy/Site/refs/heads/main/index.html
    echo "Installation terminée";
  fi
fi
