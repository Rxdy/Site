# Documentation d'Installation de Rocky Linux sur VirtualBox

Ce guide détaille le processus complet d'installation de Rocky Linux dans VirtualBox, depuis le téléchargement de l'image ISO jusqu'à la configuration du réseau en mode bridge.  
Pour information, la version de VirtualBox pour processeur ARM sous macOS peut présenter quelques différences avec d'autres versions.

## Table des matières
1. [Téléchargement de l'ISO de Rocky Linux](#téléchargement-de-liso-de-rocky-linux)
2. [Création et configuration de la machine virtuelle](#création-et-configuration-de-la-machine-virtuelle)
3. [Installation de Rocky Linux](#installation-de-rocky-linux)
4. [Configuration réseau en mode bridge](#configuration-réseau-en-mode-bridge)

---

## 1. Téléchargement de l'ISO de Rocky Linux

Commencez par télécharger l'image ISO de Rocky Linux depuis le lien ci-dessous.  
1. Choisissez d'abord votre architecture de processeur. Ici, c'est **ARM (aarch64)**.
2. Ensuite, prenez l'image par défaut avec **Boot ISO**.

[Rocky Linux Téléchargement](https://rockylinux.org/download)

![Téléchargement de l'ISO](./images/image0.png)

---

## 2. Création et configuration de la machine virtuelle

Dans cette étape, nous allons créer une nouvelle machine virtuelle dans VirtualBox pour y installer Rocky Linux, puis configurer les paramètres nécessaires.

### Étapes :

1. Ouvrez VirtualBox et cliquez sur **<span style="color:red;">Nouvelle</span>** pour créer une machine virtuelle.

![Création d'une machine virtuelle](./images/image1.png)

2. Nommez la machine.
3. Dans **ISO Image**, sélectionnez l'image ISO téléchargée précédemment.
4. Sélectionnez **Linux** comme type de système d'exploitation, puis **Fedora**. (Nous sélectionnons Fedora ici par manque de choix. Fedora fonctionne sur la même base que Rocky Linux, c'est-à-dire RedHat).

![Configuration de la Machine](./images/image2.png)

5. Assignez la quantité de mémoire RAM pour la machine virtuelle. Nous recommandons au moins **2 Go** ou plus si votre machine le permet.
6. Assignez aussi le nombre de processeurs souhaités (au minimum 1 ou plus selon votre machine).

![Configuration de la RAM et des Processeurs](./images/image3.png)

7. Les paramètres par défaut sont acceptables ici, sauf pour la quantité de mémoire. Il est recommandé de mettre au moins **15 Go** ou plus (bon à savoir : l'espace n'est pas directement alloué, donc l'espace réellement utilisé dépendra de l'usage de la machine).
8. Validez les changements et appuyez sur **<span style="color:red;">Finish</span>**.

![Paramètres système](./images/image4.png)

9. Vous êtes maintenant sur l'accueil. Sélectionnez la nouvelle machine virtuelle **1** puis cliquez sur **<span style="color:red;">Start</span>** ou **<span style="color:red;">Démarrer</span>** **2**.

![Ajout de l'ISO](./images/image4a.png)

---

## 3. Installation de Rocky Linux

L'étape suivante consiste à installer Rocky Linux.

### Étapes :
1. Lors du boot, sélectionnez **<span style="color:red;">Install Rocky Linux "9.4"</span>**. Vous pouvez faire cela avec les flèches directionnelles et la touche **Entrée** de votre clavier. (La version ici **9.4** peut évoluer, assurez-vous de prendre la dernière version disponible).

![Lancement de l'installation](./images/image5.png)

2. Sélectionnez la langue et le pays, puis validez avec **<span style="color:red;">Continuer</span>**.

![Sélection des langues](./images/image6.png)

3. L'objectif ici est de terminer la configuration de **Rocky Linux**. Pour cela, complétez les étapes affichées en rouge. Commencez par cliquer sur **<span style="color:red;">Installation Destination</span>**.

![Installation destination](./images/image7.png)

4. Cochez la case **<span style="color:red;">Je souhaite libérer de l'espace</span>**, ce qui permet de réduire la taille de la machine virtuelle au fur et à mesure de son utilisation.  
   Cliquez ensuite sur **<span style="color:red;">Fait</span>** en haut à gauche.

![Récupérer de l'espace disque](./images/image8.png)

5. Sélectionnez votre disque de **15 Go** ou plus, puis cliquez sur **<span style="color:red;">Tout supprimer</span>**.

![Récupérer de l'espace disque 2](./images/image9.png)

6. Cliquez maintenant sur **<span style="color:red;">Récupérer de l'espace</span>**.

![Récupérer de l'espace disque 3](./images/image10.png)

7. De retour sur l'écran de configuration, vérifiez que **Installation destination** n'est plus en rouge.  
   Passez à l'étape suivante en cliquant sur **<span style="color:red;">Sélectionner logiciel</span>**.

8. Choisissez **<span style="color:red;">Serveur</span>** avec l'ajout de **<span style="color:red;">Serveur Web de base</span>**.  
   Retournez sur l'écran de configuration en cliquant sur **<span style="color:red;">Fait</span>**.

![Sélection du logiciel](./images/image11.png)

9. Sélectionnez **<span style="color:red;">Mot de passe administrateur</span>** et configurez un mot de passe sécurisé. Il est conseillé de s'assurer que la sécurité est marquée **Fort**.  
   Cliquez sur **<span style="color:red;">Fait</span>** une fois terminé.

![Mot de passe administrateur](./images/image12.png)

10. Revenez à l'écran de configuration et sélectionnez **<span style="color:red;">Création utilisateur</span>**.  
    Suivez les instructions pour configurer un utilisateur avec un nom et un mot de passe sécurisé, puis cliquez sur **<span style="color:red;">Fait</span>**.

![Création d'un utilisateur](./images/image13.png)

11. Une fois toutes les configurations terminées (aucune option ne doit plus apparaître en rouge), cliquez sur **<span style="color:red;">Commencer l'installation</span>**. Cela peut prendre plusieurs minutes.

![Résumé installation](./images/image14.png)

12. Une fois l'installation terminée, cliquez sur **<span style="color:red;">Redémarrer le système</span>**.

![Progression de l'installation](./images/image15.png)

13. À l'écran de connexion, connectez-vous avec l'utilisateur **root** puis entrez le mot de passe défini précédemment.

![Interface Rocky Linux](./images/image16.png)

14. Une fois connecté, vous pouvez mettre à jour votre système en entrant la commande **`dnf update`** dans le terminal.

![Update](./images/image17.png)

15. Votre machine est maintenant prête à être utilisée.

---

## 4. Configuration réseau en mode bridge et SSH (optionnel)

Pour permettre à la machine virtuelle d'accéder au réseau local, nous devons configurer le réseau en mode bridge et activer SSH.

### Étapes :

1. Sélectionnez votre machine Rocky Linux, puis allez dans **<span style="color:red;">Configuration</span>**.

![Configuration du réseau en mode bridge](./images/image18.png)

2. Allez dans l'onglet **Réseau** et sélectionnez **Mode bridge** ou **Accès par pont** dans **Mode d'accès réseau**.  
   Appliquez les changements et redémarrez la machine pour activer les nouvelles configurations.

![Finalisation du réseau](./images/image19.png)

3. Après votre connexion, tapez la commande suivante pour obtenir votre adresse IP locale : **`ip a`**.

![Recherhce ip local](./images/image20.png)

4. Maintenant, vous pouvez vous connecter en SSH depuis votre ordinateur sur la machine virtuelle en utilisant la commande suivante :
**`ssh "username"@"ip"`** 
Par exemple, pour mon cas :
**`ssh totorow@192.168.1.180`**. 
Un mot de passe vous sera demandé.
(Il est important de noter que cela fonctionne aussi avec une adresse IPv6.).

![Preuve de la connection](./images/image21.png)

---

## Conclusion

L'installation de Rocky Linux est maintenant terminée et la machine virtuelle est prête à l'emploi. Vous pouvez commencer à utiliser votre nouvelle machine Rocky Linux pour divers projets. 
