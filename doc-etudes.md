
# DOC EXPLICATIVE DE NOTRE TRAVAIL

# Sommaire
## 1. Explication du Script de Déploiement Web
## 2. solution de lancer le script à partir du poste pc fournisseur et non serveur du client
## 3. Explication du git clone PARTIEL





# 1. Explication du Script de Déploiement Web

Ce script est conçu pour installer Apache et Git, configurer le pare-feu (pour Rocky Linux), et télécharger et déployer un site web depuis un fichier `.zip` hébergé en ligne. Voici une explication détaillée de chaque partie du script.

## Script Complet

```bash
distrib=$(cat /etc/*release* | grep "^ID=");
ipadress=$(hostname -I | cut -d ' ' -f1);

if [ "$USER" != "root" ]; then 
  echo " "
  echo "---------------------"
  echo "Erreur ! Attention, vous devez être en root pour lancer le script." 
  echo "Error ! Please, you must be root to run the script."
  echo "---------------------"
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
  wget https://raw.githubusercontent.com/Rxdy/Site/main/html.zip
  unzip html.zip
  rm -rf html.zip
  echo "Installation terminée. Pour accéder au site, utilisez le lien ci-dessous dans votre navigateur."
  echo "Installation complete. To access the site, use the link below in your browser."
  echo " "
  echo "---------------------"
  echo "http://"$ipadress
  echo "---------------------"
fi
```

## Explication du Script

### 1. Définition des Variables

```bash
distrib=$(cat /etc/*release* | grep "^ID=");
ipadress=$(hostname -I | cut -d ' ' -f1);
```

- `distrib` : Détecte la distribution Linux en recherchant l'ID dans les fichiers de release (`/etc/*release*`).
- `ipadress` : Récupère l'adresse IP principale de la machine pour fournir le lien d'accès au site web.

### 2. Vérification des Privilèges Root

```bash
if [ "$USER" != "root" ]; then 
  echo "Erreur ! Attention, vous devez être en root pour lancer le script."
  echo "Error ! Please, you must be root to run the script."
  exit
fi
```

- Vérifie si l'utilisateur est root. Si ce n'est pas le cas, le script affiche un message d'erreur et s'arrête.

### 3. Détection de la Distribution et Installation des Packages

```bash
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
```

- **Pour Rocky Linux** : Utilise `dnf` pour installer `httpd` (serveur Apache) et `git`, configure Apache pour démarrer automatiquement et ouvre le port 80 dans le pare-feu.
- **Pour Debian** : Utilise `apt` pour installer `apache2` et `git`, puis configure Apache pour démarrer automatiquement.
- **Si la distribution n'est ni Rocky Linux ni Debian**, le script affiche un message d'erreur et s'arrête.

### 4. Téléchargement et Déploiement du Site Web

```bash
cd /var/www
rm -rf html
wget https://raw.githubusercontent.com/Rxdy/Site/main/html.zip
unzip html.zip
rm -rf html.zip
```

- Se déplace dans le dossier `/var/www` (racine du serveur web).
- Supprime tout dossier `html` existant pour éviter les conflits.
- Télécharge l'archive `html.zip` du site web depuis GitHub.
- Décompresse l'archive et supprime le fichier `.zip` après extraction.

### 5. Message de Fin

```bash
echo "Installation terminée. Pour accéder au site, utilisez le lien ci-dessous dans votre navigateur."
echo "Installation complete. To access the site, use the link below in your browser."
echo "http://"$ipadress
```

- Affiche un message indiquant que l'installation est terminée et fournit l'adresse IP pour accéder au site.

## Améliorations Possibles

1. **Gestion des Erreurs** : Ajouter des vérifications pour chaque étape (téléchargement, décompression, installation) pour détecter et afficher des erreurs en cas d'échec.
2. **Compatibilité** : Ajouter des options pour d'autres distributions, si nécessaire.
3. **Utilisation du Dossier `/var/www/html`** : Par défaut, Apache utilise `/var/www/html` comme racine web. Il peut être préférable de modifier ce chemin ou de configurer Apache pour pointer vers `/var/www` si vous souhaitez déployer directement dans ce dossier.

---

Ce script est maintenant prêt pour une utilisation sur des serveurs Debian et Rocky Linux et fournit un accès simple au site en ligne.










# E 3.xplication du git clone PARTIEL
Utiliser **`git sparse-checkout`** pour un projet web comme le vôtre présente plusieurs avantages, surtout si le dépôt contient de nombreux fichiers ou si vous souhaitez déployer uniquement certaines parties du projet sur un serveur. Voici en détail pourquoi cette solution est intéressante et comment elle peut être appliquée à votre projet web :

### Avantages du Sparse Checkout dans un Projet Web

1. **Téléchargement Sélectif des Fichiers** :
   - Avec `sparse-checkout`, vous pouvez cloner uniquement les parties nécessaires du dépôt. Par exemple, si votre dépôt contient plusieurs versions du site, fichiers de documentation, ou même des assets volumineux qui ne sont pas requis pour le déploiement, vous pouvez choisir de ne rapatrier que le dossier contenant les fichiers nécessaires pour le site (par exemple, `html` ou `site`).
   - Cela permet de **réduire la bande passante et le temps de téléchargement**, en ne récupérant que ce qui est indispensable pour le serveur.

2. **Économie d’Espace Serveur** :
   - Dans certains cas, les serveurs peuvent avoir un espace de stockage limité. En téléchargeant uniquement les fichiers nécessaires, vous réduisez la taille du dépôt sur le serveur, ce qui permet d'optimiser l'espace disponible.
   - Pour un projet web simple en HTML et CSS, le fait de ne pas inclure de fichiers superflus peut rendre le projet plus léger et plus facile à gérer sur le serveur.

3. **Déploiement Ciblé et Facilité de Gestion** :
   - Vous pouvez spécifier uniquement les dossiers nécessaires pour chaque environnement. Par exemple, si vous avez un dossier `production` et un dossier `staging` dans votre dépôt, vous pouvez choisir de cloner uniquement celui qui est pertinent pour le serveur en question.
   - Cela peut faciliter la gestion de différentes configurations ou versions de votre site sans avoir à dupliquer le dépôt complet pour chaque serveur.

4. **Simplification des Mises à Jour** :
   - En rapatriant seulement une partie du dépôt, vous pouvez facilement gérer les mises à jour spécifiques au site web sans interférer avec d’autres dossiers qui ne sont pas liés au déploiement. Les prochaines exécutions de `git pull` avec `sparse-checkout` maintiendront cette structure minimale, simplifiant les mises à jour.
   - Par exemple, si vous avez besoin de mettre à jour uniquement les fichiers CSS, vous pouvez configurer le `sparse-checkout` pour ne télécharger que le dossier `css`, ce qui rend les mises à jour plus ciblées et rapides.

### Exemple d’Application au Projet Web

Supposons que votre dépôt contient la structure suivante :

```
Projet_Web/
├── docs/               # Documentation du projet
├── deploy_scripts/     # Scripts de déploiement pour différents environnements
├── site/               # Dossier contenant les fichiers du site web
│   ├── index.html
│   ├── css/
│   └── images/
└── tests/              # Tests de QA pour le projet
```

Si vous voulez uniquement les fichiers du site (contenus dans `site/`) pour le déploiement sur le serveur, vous pouvez utiliser le sparse checkout pour rapatrier uniquement ce dossier :

```bash
git clone --no-checkout <URL-du-depot>
cd Projet_Web
git sparse-checkout init --cone
git sparse-checkout set site
git checkout main
```

### Conclusion

En résumé, utiliser `git sparse-checkout` pour un projet web présente des avantages significatifs en termes de **performance**, **gestion de l’espace** et **simplicité de déploiement**. Cette approche est particulièrement utile pour les projets de vitrine où seuls les fichiers de front-end (HTML, CSS, images) sont nécessaires pour le serveur de production. 

C’est une méthode optimale pour déployer des projets légers tout en évitant la complexité et la surcharge associées aux gros dépôts.










# solution de lancer le script à partir du poste pc fournisseur et non serveur du client
Pour lancer le script de déploiement à partir de votre poste local (le PC du fournisseur) et non directement sur le serveur du client, vous pouvez utiliser **SSH** pour exécuter des commandes à distance. Cette approche est utile lorsque vous souhaitez déployer un site web ou des fichiers sans avoir à vous connecter physiquement au serveur du client. Voici une solution détaillée pour y parvenir.

### Étapes pour Lancer le Script à Distance

1. **Préparation du Serveur du Client** :
   - Assurez-vous que le serveur du client dispose d'un serveur SSH en cours d'exécution et que vous avez les droits d'accès SSH (adresse IP, nom d'utilisateur, et mot de passe ou clé SSH).
   - Le serveur doit aussi avoir une distribution compatible avec le script, comme Debian ou Rocky Linux, selon vos besoins.

2. **Création du Script de Déploiement** :
   - Écrivez votre script de déploiement sur votre poste local. Par exemple, supposons que votre script de déploiement s'appelle `deploy.sh` et qu'il est situé dans le dossier du projet.
   - Ce script doit contenir toutes les instructions nécessaires pour installer Apache, Git, configurer le pare-feu (si nécessaire), et déployer le site web.

3. **Transfert et Exécution du Script sur le Serveur du Client via SSH** :
   - Utilisez `scp` pour transférer le script `deploy.sh` sur le serveur distant.
   - Utilisez ensuite `ssh` pour exécuter le script à distance.

### Exemple de Commandes

Supposons que :
- L'adresse IP du serveur du client est `192.168.1.10`.
- Le nom d'utilisateur sur le serveur est `clientuser`.
- Le script de déploiement est dans le dossier courant et s'appelle `deploy.sh`.

#### Étape 1 : Transférer le Script sur le Serveur

Utilisez `scp` pour copier le script de déploiement sur le serveur distant.

```bash
scp deploy.sh clientuser@192.168.1.10:/tmp/deploy.sh
```

> **Remarque** : `/tmp` est un dossier temporaire où vous pouvez stocker le script. Vous pouvez aussi le placer dans un autre répertoire où `clientuser` a des droits d’écriture.

#### Étape 2 : Exécuter le Script sur le Serveur à Distance

Connectez-vous au serveur via SSH et exécutez le script :

```bash
ssh clientuser@192.168.1.10 "sudo bash /tmp/deploy.sh"
```

- Cette commande se connecte au serveur `192.168.1.10` avec l'utilisateur `clientuser`.
- Ensuite, elle exécute le script `deploy.sh` avec les privilèges `sudo` pour effectuer les actions d’installation et de configuration nécessaires.

> **Important** : Le mot de passe de l’utilisateur ou la phrase de passe pour le `sudo` pourrait être demandée au moment de l'exécution. Vous pouvez utiliser une authentification par clé SSH pour éviter de saisir le mot de passe à chaque connexion.

### Exemple de Script de Déploiement (`deploy.sh`)

Voici un exemple simplifié de ce que pourrait contenir `deploy.sh` :

```bash
#!/bin/bash

distrib=$(cat /etc/*release* | grep "^ID=")
ipadress=$(hostname -I | cut -d ' ' -f1)

if [ "$EUID" -ne 0 ]; then 
  echo "Erreur ! Ce script doit être exécuté en tant que root."
  exit 1
fi

if [[ "$distrib" == *"rocky"* ]]; then
    dnf update -y
    dnf install -y httpd git
    systemctl enable httpd && systemctl start httpd
    firewall-cmd --add-service=http --permanent
    firewall-cmd --reload
elif [[ "$distrib" == *"debian"* ]]; then
    apt update -y
    apt install -y apache2 git
    systemctl enable apache2 && systemctl start apache2
else
    echo "Cette distribution n'est pas supportée."
    exit 1
fi

cd /var/www
rm -rf html
wget https://raw.githubusercontent.com/Rxdy/Site/main/html.zip
unzip html.zip
rm -rf html.zip

echo "Installation terminée. Accédez au site à : http://$ipadress"
```

### Automatisation Complète avec un Script Local

Si vous souhaitez automatiser complètement les étapes, vous pouvez créer un script local qui combine les commandes `scp` et `ssh` :

```bash
#!/bin/bash

# Variables
SERVER_IP="192.168.1.10"
USER="clientuser"
SCRIPT_PATH="deploy.sh"
REMOTE_PATH="/tmp/$SCRIPT_PATH"

# Transférer le script
scp "$SCRIPT_PATH" "$USER@$SERVER_IP:$REMOTE_PATH"

# Exécuter le script à distance
ssh "$USER@$SERVER_IP" "sudo bash $REMOTE_PATH"
```

En exécutant ce script local, vous copierez automatiquement `deploy.sh` sur le serveur du client et l'exécuterez.

### Avantages de cette Approche

1. **Contrôle Centralisé** : Vous contrôlez le déploiement depuis votre poste local, ce qui facilite la gestion de plusieurs serveurs clients.
2. **Simplicité** : Aucun besoin de se connecter manuellement à chaque serveur ; tout est automatisé.
3. **Gain de Temps** : Si le déploiement doit être fait sur plusieurs serveurs, cette méthode permet de gagner du temps en automatisant le transfert et l'exécution du script.

### Conclusion

En utilisant SSH pour exécuter un script à distance, vous centralisez et simplifiez le processus de déploiement. Cela peut être très utile pour un fournisseur de services, car il permet de gérer plusieurs déploiements sans avoir à se connecter manuellement sur chaque serveur client.



# Référence
[^1] 
