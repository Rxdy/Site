# Documentation utilisateurs
---
## Introduction

Dans cette documentation vous retrouverez dans cette ordre : `Pré-requis`, `Préparation de l'environnement`, `Connection au serveur web`, `Héberger le site web`. De l'hébergement d'un site internet sur un `serveur web` distant en `accès par pont`. 

---
## Pré-requis

Afin de poursuivre la manipulation vous aurez besoin de :

- `VirtualBox`
- `Machine physique`*
- `Serveur physique ou serveur virtuel`*
- `Réseau par pont`*

(_Obligatoire_*)

---
## Préparation de l'environnement

Il existe deux solutions pour héberger son site sur un `serveur distant`. Il peut être sur un serveur physique ou un serveur virtuel. Si vous choisissez d'utiliser un serveur virtuel vous aurez besoin de VirtualBox.

### Installation de VirtualBox

Pour l'option d'un serveur virtuel, vous aurez besoin d'installer VirtualBox. Rendez vous sur le lien de téléchargement : https://www.virtualbox.org/wiki/Downloads

### Création d'une machine virtuel

Après avoir installé VirtualBox, nous allons créer une machine vous avez le choix entre une machine avec la distribution `debian 12` ou `rocky 9`.

Voici ou vous pouvez retrouver les ISO des distributions respective :

- `Debian 12 :` https://www.debian.org/distrib/ 
- `Rocky 9 :` https://rockylinux.org/fr/download

Si vous prenez le choix de la distribution rocky nous avons une documentation pour l'installation :
Pour debian, voici un lien pour un tutoriel sur youtube : https://www.youtube.com/watch?v=2JIBxi7tywY

### Paramétrage réseau en accès par pont

Attention a bien configurer le réseau de la machine virtuel. `Clique droit sur la machine virtuel` -> `Configuration` -> `Réseau`.

Changer le mode d'accès réseau par : `Accès par pont`.

---
## Connection au serveur web

### Adresse IP

Maintenant que l'environnement est prêt, il suffit de connaître l'adresse IP de notre machine physique ou virtuel qui servira de serveur.
Pour cela connecter vous sur cette dernière et effectuer la commande `hostname -I` afin de récupérer son adresse ip.

### Connection SSH

Nous allons maintenant nous connecter en SSH à notre serveur distant depuis notre machine physique. Ouvrer votre invite de commande, et taper la commande suivant : `ssh -p 22 NomDeLaMachine@AdresseIP`. Saisissez vos identifiants, nom d'utilisateur et mot de passe.
(Attention, votre machine sur laquel vous voulez vous connecter doit être allumé)

Bravo, vous avez maintenant accès à votre serveur depuis votre machine.

### Connection en administrateur

Il faut désormais que vous vous connectiez en administrateur. Pour cela effectuer la commande : `su -`. Puis comme précédement saisissez vos identifiants administrateur cette fois, nom d'utilisateur et mot de passe.

 Bravo, vous êtes connecté en tant que administrateur sur la machine.

---
## Héberger le site web

### Installation du site sur le serveur

Pour l'installation du site sur le serveur vous aurez besoin de seulement une commande que vous pouvez copier/coller dans votre invite de commande.

Commande : `wget -qO- https://bit.ly/lenofo | bash` 

---


