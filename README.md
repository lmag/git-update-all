# Git Update All 🚀

Une collection de scripts natifs Windows Batch (`.bat`) et Linux Bash (`.sh`) pour automatiser le clonage, la mise à jour et la gestion de dépôts Git (spécialement conçus pour les modules Dolibarr Evarisk/Eoxia).

## À propos du projet

Ce dépôt contient deux ensembles d'outils parallèles :
1. **Une suite Windows (.bat)** entièrement refondue et pilotée par un fichier CSV, offrant une flexibilité maximale et la sélection intelligente entre dépôts originaux et forks.
2. **Une suite Linux/macOS (.sh)** classique, parfaite pour mettre en place rapidement un environnement via des scripts Bash.

---

## 🟦 Version Windows (.bat avec configuration CSV)

La suite Windows est la plus avancée. Elle offre une expérience robuste sans dépendance à PowerShell ni problèmes d'exécution.

### Fonctionnalités Windows ✨
* ✅ **Configuration par CSV** : L'intégralité des dépôts à cloner est gérée depuis le fichier `list-repo-to-clone.csv`.
* ✅ **Logique Intelligente Repo/Fork** : Le script détecte si vous souhaitez cloner le dépôt source ou votre propre fork en analysant les URLs via le mot-clé saisi.
* ✅ **Modes d'installation** : `0` (Ignorer), `1` (Interactif `o/N`), `2` (Automatique / Mode Ninja).
* ✅ **Mode Ninja (Confirmation Unique)** : Détecte en amont tous les modules configurés pour une installation automatique (`toclone=2`), les présente en liste et demande une confirmation globale unique avant le lancement du clonage.
* ✅ **Sécurité anti-écrasement** : Le script de déploiement (`10_deploy_all.bat`) détecte si le fichier de configuration `.csv` existe déjà dans le répertoire cible pour ne pas écraser les personnalisations de l'utilisateur.
* ✅ **Parsing CSV robuste** : Prise en charge robuste des champs vides (comme les colonnes de branches vides) pour éviter tout décalage de colonnes.
* ✅ **Gestion des branches** : Possibilité de cibler une branche spécifique (ex: `develop`, `v23`) ou de laisser la branche par défaut.
* ✅ **Journalisation (Logging)** : Toutes les actions sont consignées avec un horodatage précis dans `git_update.log`.


### Utilisation sous Windows

#### Ordre d'exécution recommandé :
1. **`10_deploy_all.bat`** : Copie automatiquement les autres scripts numérotés et le fichier CSV dans le dossier parent (ex: `custom/`).
2. Remontez dans le dossier parent.
3. **`20_install_modules.bat`** : Lance le moteur de clonage dynamique basé sur le CSV.
4. **`30_git-update-all.bat`** : Parcourt tous les sous-dossiers existants et effectue un `git pull` pour les mettre à jour.
5. **`100_cleanup_all.bat`** : Supprime les scripts de maintenance de l'espace de travail (sans affecter vos dépôts).

#### Configuration via CSV (`list-repo-to-clone.csv`)
Structure stricte : `repo-or-fork,forkedfrom,branch,repo,dossier_cible,toclone`
1. **`repo-or-fork`** : Le mot-clé (ex: `lmag`, `evarisk`, `eoxia`).
2. **`forkedfrom`** : L'URL du dépôt original officiel.
3. **`branch`** : La branche à cibler (`""` pour utiliser la branche par défaut).
4. **`repo`** : L'URL de votre fork personnel.
5. **`dossier_cible`** : Nom du dossier local à créer.
6. **`toclone`** : `0` (Ignoré silencieusement), `1` (Interactif), `2` (Installation automatique).

**Exemple : Cloner mon propre fork (`lmag`)**
`lmag,https://github.com/evarisk/digirisk,"",https://github.com/lmag/digirisk,digiriskdolibarr,1`
👉 Le script lit `lmag`, vérifie dans quelle URL ce mot-clé se trouve, et clone donc l'URL du fork.

---

## 🐧 Version Linux / macOS (.sh)

La suite Linux contient des scripts Bash conçus pour des tâches d'automatisation interactives et rapides.

### Fonctionnalités Linux ✨
* ✅ **Installation par lots** : Installez des collections entières de modules en une commande.
* ✅ **Configuration granulaire** : Éditez directement les tableaux associatifs bash dans le script.
* ✅ **Déploiement simple** : Copie les scripts et les rend exécutables (`chmod +x`) automatiquement.

### Nos Scripts Bash 🛠️

#### 1. `install_modules.sh`
Assistant interactif pour cloner des listes de dépôts Git.
**Comportement** : Demande d'abord confirmation pour parcourir un groupe de modules, puis demande `o/N` pour chaque dépôt spécifique.
**Personnalisation** : Pour ajouter un module, éditez les tableaux associatifs au début du script :
```bash
declare -A evarisk_repos=(
    ["https://github.com/Evarisk/Digirisk"]="digiriskdolibarr"
    ["https://github.com/Evarisk/Saturne"]="saturnedolibarr"
    # Ajoutez votre nouveau module ici
)
```

#### 2. `deploy_all.sh`
Utilitaire pratique pour copier tous les scripts d'un dossier vers son parent en les rendant exécutables.
**Comportement** : S'ignore lui-même, copie les `.sh` dans `../`, applique `chmod +x` et génère un log des opérations dans `git_update.log`.

---

## Prérequis Communs

La seule dépendance nécessaire est `git`. Assurez-vous qu'il est installé sur votre système.
```sh
# Sur Debian/Ubuntu par exemple :
sudo apt-get install git
```

## Installation

Clonez ce dépôt sur votre machine locale :
```sh
git clone https://github.com/lmag/git-update-all.git
cd git-update-all
```

---

## FAQ

### Pourquoi ai-je cette erreur sous Linux : "bash: ./update_git_all.sh : /bin/bash^M : mauvais interpréteur: Aucun fichier ou dossier de ce type" ?

L'erreur est causée par le caractère de retour à la ligne Windows (`^M` ou `CRLF`) à la fin de la première ligne de votre script Bash.

**Solution 1 : La commande sed (Méthode rapide et universelle)**
L'outil `sed` est disponible sur la quasi-totalité des systèmes Linux :
```sh
sed -i 's/\r$//' nom_du_script.sh
```

**Solution 2 : Avec VS Code**
1. En bas à droite de la fenêtre, vous devriez voir `CRLF`. 
2. Cliquez dessus et changez-le pour `LF`. 
3. Sauvegardez ensuite le fichier.

**Solution 3 : Avec vim**
1. Ouvrez le fichier : `vim nom_du_script.sh`
2. Passez en mode commande (touche `Échap`)
3. Tapez `:set fileformat=unix` et appuyez sur `Entrée`.
4. Sauvegardez et quittez : `:wq`

---

## 🛠️ Dossier d'outillage (Scratch)

Un répertoire `scratch/` (configuré dans le `.gitignore`) est réservé pour le stockage de scripts utilitaires ou de débogage temporaires, garantissant que le dépôt reste propre et exempt de fichiers temporaires de développement.

