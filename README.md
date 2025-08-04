# git-update-all
Voici un script shell pour Linux qui parcourt tous les sous-répertoires, vérifie s'il s'agit de dépôts Git, et exécute `git pull` si c'est le cas. Toute la sortie (succès et erreurs) est enregistrée dans un fichier de log.

-----

# Comment l'utiliser

1.  **Enregistrez le script** : Placez le fichier `update_all.sh` dans le répertoire parent contenant tous vos projets (celui que vous avez montré dans votre `ls -l`).

2.  **Rendez-le exécutable** : Ouvrez un terminal dans ce répertoire et exécutez la commande suivante pour donner les permissions d'exécution au script.

    ```shell
    chmod +x update_all.sh
    ```

3.  **Lancez le script** : Exécutez simplement le script.

    ```shell
    ./update_all.sh
    ```

À la fin de l'exécution, un fichier nommé `git_update.log` sera créé (ou mis à jour) dans le même dossier. Il contiendra un historique détaillé de toutes les opérations `git pull` effectuées.

-----

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
  
