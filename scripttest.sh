#!/bin/bash

# Variable pour stocker la distribution du serveur.
distrib=$(cat /etc/*release* | grep "^ID=");
# Variable pour stocker l'adresse du serveur.
ipadress=$(hostname -I | cut -d ' ' -f1);
# Variable pour stocker le chemin d'apache où l'on stock les fichiers du site et éviter de le répeter et si besoin le changer ici pour tout le script.
path="/var/www/html/lenofo"

# Condition pour savoir si l'utilisateur connecté est de type root
if [ "$USER" != "root" ]; then
  # L'utilisateur n'est pas de type root.
  # Affiche un message d'erreur.
  echo "---------------------------------------------------------------------"
  echo "Erreur ! Attention, vous devez être en root pour lancer le script." 
  echo "Error ! Please, you must be root to run the script."
  echo "---------------------------------------------------------------------"

else
  # L'utilisateur est de type root.
  # Test de la distribution du serveur.
  if [ "$distrib" == 'ID="rocky"' ]; then
    # Le serveur est de type rocky.
    # Update du système.
    dnf update -y
    # Installation de UNZIP.
    dnf install -y unzip
    # Installation d'apache.
    dnf install -y httpd
    # Activation du service d'apache, au cas où.
    systemctl enable httpd && systemctl start httpd
    # Ajout de règle au pare-feu, service 'http' => permanent.
    firewall-cmd --add-service=http --permanent
    # Rechargement du pare-feu.
    firewall-cmd --reload

  elif [ "$distrib" == 'ID=debian' ]; then
    # Le serveur est de type debian.
    # Update du système.
    apt update -y
    # Installation de UNZIP.
    apt install -y unzip
    # Installation d'apache.
    apt install -y apache2
    # Activation du service d'apache, au cas où.
    systemctl enable apache2 && systemctl start apache2
  else
    # Ce type de distribution n'est pas géré par le script.
    # Affiche un message d'erreur.
    echo "----------------------------------------------------------------------------------------------"
    echo "Cette distribution n'est pas supportée. Une distribution Rocky Linux ou Debian est demandée."
    echo "This distribution is not supported. A Rocky Linux or Debian distribution is required."
    echo "----------------------------------------------------------------------------------------------"
    # Sors du script.
    exit
  fi
  # On force la suppression du fichier lenofo, si il y en a déjà un. Lors d'une mise à jour par exemple.
  rm -rf $path
  # On créé un dossier.
  mkdir $path
  # On se déplace dans le dossier.
  cd $path
  # Téléchargement du zip dans le GitHub.
  wget https://raw.githubusercontent.com/Rxdy/Site/main/lenofo.zip
  # Unzip du fichier que l'on viens de télécharger.
  unzip lenofo.zip -d $path
  # Suppression du fichier zip : lenofo.zip. 
  rm -f $path/lenofo.zip 
  # Variable pour stocker les fichiers présent dans l'emplacement d'apache.
  testZip=$(ls $path);
  # Condition pour savoir si il y a des fichiers dans le dossier d'apache.
  if [ "$testZip" == '' ]; then
    # Aucun fichier trouvé dans le répertoire.
    # Affiche un message d'erreur.
    echo " "
    echo "Erreur : Problème avec le fichier zip."
    echo "Error : Problem with the zip file."
    echo " "
  else
    # Installation réussi.
    # Affiche un message d'erreur.
    echo " "
    echo "Installation terminée. Pour accéder au site, utilisez le lien ci-dessous dans votre navigateur."
    echo "Installation complete. To access the site, use the link below in your browser."
    echo " "
    echo "------------------------------"
    echo "| http://$ipadress/lenofo |"
    echo "------------------------------"
    echo " "
  fi
# Sors du script.
exit
fi
