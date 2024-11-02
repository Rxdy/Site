Voici l'explication du script en Markdown, organisée de manière globale, par blocs, puis ligne par ligne.

---

# Explication du Script

## Vue d’ensemble
Ce script Bash est conçu pour automatiser l’installation d’un site web sur un serveur utilisant **Apache**. Il est compatible avec **Debian** et **Rocky Linux**. Le script vérifie d'abord que l'utilisateur est `root`, détecte le type de distribution, met à jour le système, installe les dépendances nécessaires (comme `apache` et `unzip`), puis télécharge et extrait les fichiers du site depuis GitHub. À la fin, il affiche l'adresse IP pour accéder au site.

## Explication par bloc

### Bloc 1 : Initialisation des variables
Le script commence par définir plusieurs variables :
- `distrib` : Stocke le type de distribution Linux (ex : Debian ou Rocky Linux).
- `ipadress` : Stocke l'adresse IP principale du serveur.
- `path` : Définit le chemin d'installation du site web.

### Bloc 2 : Vérification des permissions `root`
Ce bloc vérifie si le script est exécuté par l'utilisateur `root`. Si ce n'est pas le cas, un message d'erreur est affiché, et le script s'arrête. Cela garantit que seules les personnes ayant les permissions nécessaires peuvent exécuter les commandes sensibles du script.

### Bloc 3 : Installation et configuration en fonction de la distribution
Ce bloc vérifie la distribution du serveur (`Debian` ou `Rocky Linux`) et exécute les commandes spécifiques à chaque distribution pour :
- Mettre à jour le système.
- Installer les packages `unzip` et `apache`.
- Activer et démarrer le service Apache.
- Configurer le pare-feu pour autoriser les connexions HTTP sur `Rocky Linux`.

### Bloc 4 : Téléchargement et extraction du fichier zip du site
Une fois les packages installés, ce bloc télécharge une archive `.zip` du site web depuis GitHub, l'extrait dans le dossier d'installation et supprime le fichier zip après extraction.

### Bloc 5 : Vérification de l'extraction et affichage de l'URL
Ce dernier bloc vérifie si des fichiers sont bien présents dans le dossier cible après extraction. S'il n'y a aucun fichier, un message d'erreur est affiché. Sinon, le script affiche l'URL du site pour que l’utilisateur puisse y accéder via le navigateur.

---

## Explication ligne par ligne

```bash
#!/bin/bash
```
- **Shebang** : Spécifie que le script doit être exécuté avec l'interpréteur `bash`.

```bash
# Variable pour stocker la distribution du serveur.
distrib=$(cat /etc/*release* | grep "^ID=");
```
- **distrib** : Exécute une commande pour extraire l'identifiant de la distribution (Debian, Rocky, etc.) depuis les fichiers système `/etc/*release*`.

```bash
# Variable pour stocker l'adresse du serveur.
ipadress=$(hostname -I | cut -d ' ' -f1);
```
- **ipadress** : Utilise `hostname -I` pour récupérer l'adresse IP du serveur, puis utilise `cut` pour isoler la première adresse IP.

```bash
# Variable pour stocker le chemin d'apache où l'on stock les fichiers du site et éviter de le répeter et si besoin le changer ici pour tout le script.
path="/var/www/html/lenofo"
```
- **path** : Définit le chemin où les fichiers du site seront stockés, ce qui permet de le modifier en un seul endroit si nécessaire.

```bash
# Condition pour savoir si l'utilisateur connecté est de type root
if [ "$USER" != "root" ]; then
```
- **Vérification de l’utilisateur** : Vérifie si le script est exécuté par `root`. Si ce n'est pas le cas, il affiche un message d'erreur.

```bash
  echo "Erreur ! Attention, vous devez être en root pour lancer le script." 
  echo "Error ! Please, you must be root to run the script."
  exit
```
- **Message d’erreur et sortie** : Affiche un message d'erreur et arrête le script si l'utilisateur n'est pas `root`.

```bash
else
```
- **Sinon** : Si l’utilisateur est bien `root`, continue l'exécution du script.

```bash
  if [ "$distrib" == 'ID="rocky"' ]; then
```
- **Détection de Rocky Linux** : Vérifie si la distribution est Rocky Linux.

```bash
    dnf update -y
    dnf install -y unzip
    dnf install -y httpd
    systemctl enable httpd && systemctl start httpd
    firewall-cmd --add-service=http --permanent
    firewall-cmd --reload
```
- **Mise à jour et installation sur Rocky Linux** :
  - Met à jour le système avec `dnf`.
  - Installe `unzip` et `httpd` (Apache).
  - Active et démarre le service Apache.
  - Configure le pare-feu pour autoriser HTTP.

```bash
  elif [ "$distrib" == 'ID=debian' ]; then
```
- **Détection de Debian** : Vérifie si la distribution est Debian.

```bash
    apt update -y
    apt install -y unzip
    apt install -y apache2
    systemctl enable apache2 && systemctl start apache2
```
- **Mise à jour et installation sur Debian** :
  - Met à jour le système avec `apt`.
  - Installe `unzip` et `apache2`.
  - Active et démarre le service Apache.

```bash
  else
    echo "Cette distribution n'est pas supportée..."
    exit
  fi
```
- **Gestion d'autres distributions** : Affiche un message d'erreur si la distribution n'est pas prise en charge et arrête le script.

```bash
  rm -rf $path
  mkdir $path
  cd $path
```
- **Préparation du dossier** :
  - Supprime le dossier cible s'il existe déjà.
  - Crée un nouveau dossier pour stocker les fichiers du site.
  - Change le répertoire de travail pour celui du site.

```bash
  wget https://raw.githubusercontent.com/Rxdy/Site/main/lenofo.zip
  unzip lenofo.zip -d $path
  rm -f $path/lenofo.zip
```
- **Téléchargement et extraction** :
  - Télécharge l’archive zip du site depuis GitHub.
  - Extrait son contenu dans le dossier cible.
  - Supprime l'archive une fois l'extraction terminée.

```bash
  testZip=$(ls $path);
```
- **testZip** : Stocke le résultat de `ls` pour vérifier si des fichiers sont présents dans le dossier.

```bash
  if [ "$testZip" == '' ]; then
    echo "Erreur : Problème avec le fichier zip."
  else
    echo "Installation terminée. Pour accéder au site, utilisez le lien ci-dessous dans votre navigateur."
    echo "| http://$ipadress/lenofo |"
  fi
```
- **Vérification de l'installation** :
  - Si aucun fichier n'est présent dans le dossier, affiche un message d'erreur.
  - Sinon, affiche l'URL du site pour que l’utilisateur puisse y accéder.

---

En suivant cette explication détaillée, le script devient plus clair pour toute personne souhaitant le comprendre et l’adapter.