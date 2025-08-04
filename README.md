# git-update-all
Voici un script shell pour Linux qui parcourt tous les sous-répertoires, vérifie s'il s'agit de dépôts Git, et exécute `git pull` si c'est le cas. Toute la sortie (succès et erreurs) est enregistrée dans un fichier de log.

-----

## Comment l'utiliser

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
