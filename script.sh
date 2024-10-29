distrib=$(cat /etc/*release* | grep "^ID=");

ipadress=$(hostname -I | cut -d ' ' -f1);

if [ "$USER" != "root" ]; then 
  echo "Erreur ! Attention, vous devez être en root pour lancer le script." 
  echo "Error ! Please, you must be root to run the script."
else
  if [ "$distrib" == 'ID="rocky"' ]; then
    dnf update -y
    dnf install -y httpd
    dnf install -y git
    systemctl enable httpd && systemctl start httpd
    firewall-cmd --add-service=http --permanent
    firewall-cmd --reload
  elif [ "$distrib" == 'ID=debian' ]; then
    apt update -y
    apt install -y apache2
    apt install -y git
    systemctl enable apache2 && systemctl start apache2
  else
      echo "Cette distribution n'est pas supportée. Une distribution Rocky Linux ou Debian est demandée."
      echo "This distribution is not supported. A Rocky Linux or Debian distribution is required."
      exit
  fi
  cd /var/www
  rm -rf html
  git clone https://github.com/Rxdy/html.git temp-repo
  cp -r temp-repo/html/* /var/www
  rm -rf temp-repo
  echo "Installation terminée. Pour accéder au site, utilisez le lien ci-dessous dans votre navigateur."
  echo "Installation complete. To access the site, use the link below in your browser."
  echo " "
  echo "---------------------"
  echo "http://"$ipadress
  echo "---------------------"
fi
