# Git Update All 🚀

Une collection de scripts shell pour automatiser le clonage de dépôts Git et le déploiement de scripts utilitaires.

## À propos du projet

Ce dépôt contient un ensemble de scripts Bash conçus pour simplifier deux tâches courantes pour les développeurs :

1.  **Installer des modules en masse** depuis des listes de dépôts GitHub prédéfinies.
2.  **Déployer rapidement** un ensemble de scripts d'un répertoire de travail vers un répertoire parent.

Ces outils ont été conçus pour être interactifs, configurables et fournir des retours clairs à l'utilisateur.

-----

## Fonctionnalités principales ✨

  * ✅ **Installation de modules par lots** : Installez des collections entières de modules (par exemple, Evarisk, Eoxia) en une seule commande.
  * ✅ **Configuration granulaire** : Confirmez l'installation pour chaque module individuellement, avec un affichage clair du dépôt source et du dossier de destination.
  * ✅ **Personnalisation facile** : Modifiez simplement les listes de dépôts et les noms des dossiers de destination directement dans le script.
  * ✅ **Déploiement de scripts** : Copiez tous les scripts `.sh` d'un répertoire et rendez-les exécutables dans le dossier parent.
  * ✅ **Sécurité et traçabilité** : Le script de déploiement s'ignore lui-même pour éviter toute manipulation accidentelle et conserve un journal de toutes les actions effectuées.

-----

## Prérequis

La seule dépendance nécessaire est `git`. Assurez-vous qu'il est installé sur votre système.

```sh
# Sur les systèmes basés sur Debian/Ubuntu
sudo apt-get install git
```

-----

## Installation

Pour commencer, clonez simplement ce dépôt sur votre machine locale :

```sh
git clone https://github.com/lmag/git-update-all.git
cd git-update-all
```

Tous les scripts seront alors disponibles et prêts à être utilisés. N'oubliez pas de les rendre exécutables si nécessaire.

-----

## Nos Scripts 🛠️

### 1\. `install_modules.sh`

Ce script est un assistant interactif pour cloner des listes de dépôts Git. Il est parfait pour mettre en place rapidement un environnement de développement avec de nombreux modules.

**Comment l'utiliser ?**

```sh
./install_modules.sh
```

**Comportement :**

1.  Le script vous demande d'abord si vous souhaitez parcourir un groupe de modules (ex: "Evarisk").
2.  Si vous acceptez, il parcourt chaque module du groupe, un par un.
3.  Pour chaque module, il vous présente :
      * Le dépôt Git source.
      * Le nom du répertoire de destination personnalisé.
4.  Il vous demande alors une confirmation (o/N) avant de lancer le `git clone`.
5.  Vous avez ainsi un contrôle total sur ce qui est installé.

### 2\. `deploy_all.sh`

Un utilitaire pratique pour copier tous les scripts d'un dossier vers son parent, en les rendant immédiatement exécutables.

**Comment l'utiliser ?**

```sh
# Assurez-vous que deploy_all.sh est dans le dossier avec les autres scripts à déployer
./deploy_all.sh
```

**Comportement :**

1.  Le script recherche tous les fichiers se terminant par `.sh` dans le répertoire courant.
2.  **Il s'ignore lui-même** pour éviter de se copier.
3.  Pour chaque autre script trouvé, il le copie dans le répertoire parent (`../`) et lui applique la permission d'exécution (`chmod +x`).
4.  Toutes les actions sont enregistrées avec un horodatage dans un fichier journal nommé `git_update.log`, situé dans le répertoire parent.

-----

## Personnalisation ⚙️

Le script `install_modules.sh` est conçu pour être facilement adaptable à vos besoins.

Pour ajouter, modifier ou supprimer des modules, il suffit d'éditer les tableaux associatifs au début du script. La structure est `["URL_DU_DEPOT"]="NOM_DU_DOSSIER"`.

**Exemple : Ajouter un nouveau module à la liste Evarisk**

Ouvrez `install_modules.sh` et trouvez cette section :

```bash
declare -A evarisk_repos=(
    ["https://github.com/Evarisk/Digirisk"]="digiriskdolibarr"
    ["https://github.com/Evarisk/Saturne"]="saturnedolibarr"
    # ... autres modules
    # Ajoutez votre nouveau module ici
    ["https://github.com/Evarisk/MonNouveauModule"]="monnouveaumodule-dolibarr"
)
```

Enregistrez le fichier, et votre nouveau module sera proposé lors de la prochaine exécution du script \!

-----

## Contributions

Les contributions sont les bienvenues \! Si vous avez des idées d'amélioration ou des corrections de bugs, n'hésitez pas à ouvrir une "Issue" ou à soumettre une "Pull Request".

# FAQ

## Pourquoi j'ai cette erreur "bash: ./update_git_all.sh : /bin/bash^M : mauvais interpréteur: Aucun fichier ou dossier de ce type"

L'erreur "mauvais interpréteur" : Aucun fichier ou dossier de ce type est causée par le caractère ^M à la fin de la première ligne de votre script.

### Solution 1 : On ouvre avec vim

1. Ouvrez le fichier : vim update_git_all.sh
2. Passez en mode commande (en appuyant sur Échap)
3. Tapez :set fileformat=unix et appuyez sur Entrée.
4. Sauvegardez et quittez : :wq

### Solution 2 : Avec VS Code
1. En bas à droite de la fenêtre, vous devriez voir CRLF. 
2. Cliquez dessus et changez-le pour LF. 
3. Sauvegardez ensuite le fichier.

### Solution 3 : La méthode universelle la commande sed
L'outil sed est disponible sur la quasi-totalité des systèmes Linux et peut faire la même chose. Exécutez cette commande pour supprimer les caractères ^M de votre fichier :
    
    sed -i 's/\r$//' update_git_all.sh
  
