# Document explicatif sur le projet d’installation d’un site Web via script

## 1. Introduction

Nous nous sommes mis en place, ce qui nous a permis d’aborder notre projet avec sérieux. Plutôt que de chercher à aller vite, nous avons pris le temps de concevoir un processus d’installation automatisée de site web, fiable et simple à utiliser. À chaque étape du développement, nous avons réfléchi à comment rendre l’expérience utilisateur la plus fluide possible tout en assurant une installation robuste et en anticipant les défis techniques que nous pourrions rencontrer.

## 2. Méthodologie
Nous avons travaillé principalement via des appels sur Discord, parfois en petits groupes de deux à quatre personnes. Le développement principal a été réalisé par un codeur, tandis que les autres membres se concentraient sur des recherches de solutions et des tests. C'est en partie pour cela que le nombre de COMMITS est inégal. Nous avons choisi de publier notre code sur un dépôt GitHub public pour assurer la compatibilité avec `wget`, ce qui aurait pu être problématique avec un dépôt privé.

## 3. Déroulement du projet

### 3.1 Inspiration de RunTipi
Nous nous sommes inspirés d’un script d’installation déjà connu, celui de RunTipi, qui utilise la commande suivante :

`curl -L https://setup.runtipi.io | bash`

- Lien du script RunTipi : [https://setup.runtipi.io](https://setup.runtipi.io)

À partir de cette idée, nous avons développé un premier script d’installation avec `wget` (qui est disponible nativement sur les distributions linux.), permettant le téléchargement direct depuis GitHub. Nous avons effectué nos premiers tests sous Debian, avec un simple fichier `index.html` au départ.

### 3.2 Vérification des droits Root
Après avoir effectué plusieurs tests entre nous, nous avons rencontré des problèmes de permissions lorsque le script était exécuté en tant qu’utilisateur standard. Pour garantir que le script s’exécute avec les droits nécessaires, nous avons ajouté une étape de vérification pour nous assurer que l’utilisateur est bien en mode root sinon un message explicatif est donné.

Pour implémenter cette vérification, nous avons suivi les instructions trouvées sur le forum Ubuntu :
- [https://forum.ubuntu-fr.org/viewtopic.php?id=324110](https://forum.ubuntu-fr.org/viewtopic.php?id=324110)

### 3.3 Adaptation pour Debian et Rocky Linux

Lors de l'adaptation de notre script pour qu'il fonctionne à la fois sur Debian et Rocky Linux, nous avons dû prendre en compte les différences entre les gestionnaires de paquets de ces deux distributions.

#### Gestionnaires de paquets

- **Debian** utilise le gestionnaire de paquets `APT` (Advanced Package Tool). 
Les commandes avec `APT` sont par exemple: 
`apt update`

- **Rocky Linux**, quant à lui, utilise `DNF` (Dandified YUM).
Les commandes avec `DNF` sont par exemple:
`dnf update`

Nous avons créé une seconde version du script compatible avec Rocky Linux. Les différences notables incluent le fait que Debian utilise `apache2` pour le serveur web, tandis que Rocky Linux utilise `httpd`. De plus, sous Rocky Linux, il est nécessaire de modifier les règles du pare-feu pour permettre l'accès au port 80. Nous avons trouvé les informations nécessaires à ce sujet sur :  
- [https://fr.linux-console.net/?p=29605](https://fr.linux-console.net/?p=29605)

### 3.4 Détection automatique de la distribution
Pour rassembler les scripts en un seul, nous avons ajouté une détection automatique de la distribution (Debian ou Rocky Linux) grâce à la commande suivante :

`cat /etc/*release*`

- Source de cette commande : [http://www.tux-planet.fr/connaitre-la-version-de-linux-installe/](http://www.tux-planet.fr/connaitre-la-version-de-linux-installe/)

### 3.5 Messages d’information utilisateur
Pour rendre le script plus intuitif, nous avons ajouté des messages expliquant le succès ou les erreurs d’exécution, ainsi qu’un lien vers l’adresse IP du site web installé. Nous avons touvé un moyen facile de récupérer l'addresse ip grace au site : [https://fr.linux-console.net/?p=29567](https://fr.linux-console.net/?p=29567)

Cela facilite le processus, car le résultat est affiché sur une seule ligne, ce qui rend le stockage de la variable dans le script plus simple et permet d'effectuer des opérations de filtrage et de traitement.

Et la commande : `hostname -I`

### 3.6 Autre recherche et Variable
Nous avons également utilisé des variables pour stocker certains résultats de commandes, en suivant les indications du site :  
- [https://www.it-connect.fr/mettre-le-resultat-dune-commande-dans-une-variable/](https://www.it-connect.fr/mettre-le-resultat-dune-commande-dans-une-variable/)

Nous avons aussi beaucoup rechercher de commande avec le Man intégré à Linux et sur internet avec des recherches poussé sur le grep, egrep, cut et bien d'autre.

""""détaille du cut""""

### 3.7 Simplification de l’exécution du script

Pour simplifier l’exécution du script, nous avons généré un lien raccourci permettant d'exécuter le script en une seule commande. Cela est particulièrement utile si l'utilisateur ne peut pas effectuer de copier-coller.

**Commande originale :**
`wget -qO- https://raw.githubusercontent.com/Rxdy/Site/refs/heads/main/script.sh | bash`

**Lien raccourci :**
`wget -qO- https://bit.ly/lenofo | bash`

## 4. Problèmes rencontrés et solutions

### 4.1 Structure de fichiers multiples et liens RAW sur GitHub

Une des étapes les plus complexes pour nous a été la mise en place d’une structure de site web avec plusieurs pages et des images. Voici les différentes étapes par lesquelles nous sommes passés pour arriver à une solution fonctionnelle.

#### Tentative 1 : Utilisation de `wget` pour télécharger un dossier

Nous avons d'abord tenté de télécharger un dossier complet contenant plusieurs fichiers via `wget`. Cette solution aurait permis de simplifier l'installation en téléchargeant tout le site d'un coup, mais nous avons rapidement constaté que `wget` ne peut pas télécharger directement des répertoires. Cette première approche n’était donc pas viable. et faire faire fichier par fichier n'était pas optimisé et complex en cas de modification du site web.

#### Tentative 2 : Utilisation d’un dossier compressé (ZIP)

Pour contourner la limitation de `wget`, nous avons décidé d'essayer avec un fichier ZIP. En compressant les fichiers du site, nous pouvions envisager de télécharger ce fichier ZIP, puis de le décompresser pour installer le site. Cependant, GitHub propose deux types d'URL : 
1. Une URL classique pour visualiser les fichiers dans un navigateur : `https://github.com/Rxdy/Site/blob/main/script.sh`
2. Une URL dite "RAW" pour accéder directement aux fichiers bruts : `https://raw.githubusercontent.com/Rxdy/Site/refs/heads/main/script.sh`

Nous utilisions déjà l’URL RAW pour télécharger le script d’installation, mais nous avons découvert qu’il n'existe pas d’URL RAW pour les fichiers ZIP sur GitHub, ce qui a rendu cette solution impossible.

#### Tentative 3 : Utilisation de `git clone` pour cloner le dépôt

Pour contourner cette limite, nous avons décidé d'utiliser `git clone` pour cloner directement notre dépôt GitHub et récupérer tous les fichiers nécessaires en une seule commande. Cette solution fonctionnait bien sous Rocky Linux, mais a posé problème sous Debian, où un identifiant GitHub était requis pour cloner le dépôt. 

Après avoir effectué des recherches, nous avons trouvé une alternative permettant de télécharger directement une version spécifique de Git sous Debian pour contourner ce problème. Voici la commande que nous avons trouvée :

`wget https://github.com/git/git/archive/refs/tags/v2.35.1.zip -O git.zip`

- Source : [https://www.digitalocean.com/community/tutorials/how-to-install-git-on-debian-10](https://www.digitalocean.com/community/tutorials/how-to-install-git-on-debian-10)

#### Solution finale : Ajustement de l’URL du fichier ZIP

Après plusieurs essais, nous avons découvert qu’il était possible de configurer notre dépôt pour utiliser une URL permettant un téléchargement direct du ZIP sans problème. Nous avons ainsi modifié l’URL GitHub pour pointer vers une version téléchargeable en ligne directe :
- URL modifiée pour le fichier ZIP : [https://raw.githubusercontent.com/Rxdy/Site/blob/main/lenofo.zip](https://raw.githubusercontent.com/Rxdy/Site/blob/main/lenofo.zip)

Nous avons cependant constaté qu'il fallait patienter quelques minutes après chaque modification du fichier sur GitHub avant de télécharger, car GitHub semble prendre un certain temps pour synchroniser les fichiers. Sans cette attente, `wget` pouvait renvoyer une archive ZIP corrompue.


## 5. Conclusion
Notre objectif était de rendre l’installation aussi simple et automatisée que possible pour l’utilisateur final. Nous avons centralisé toutes les étapes dans un seul script, compatible à la fois avec Debian et Rocky Linux comme demandé dans les consignes. Le script ne s'execute pas sous d'autres distribution cependent il est facilement adaptable pour les autres. Cette expérience nous a permis de développer des compétences avancées en scripting Bash et en gestion de systèmes Linux tout en rendant notre solution accessible et facile à utiliser.
