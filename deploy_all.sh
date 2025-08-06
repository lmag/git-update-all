#!/bin/bash
# Copyright (C) 2025  Laurent Magnin
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# Définit le chemin du fichier de log dans le répertoire parent.

# Définit le chemin du fichier de log dans le répertoire parent.
LOG_FILE="../git_update.log"

# --- AJOUT : Récupère le nom de ce script pour l'ignorer dans la boucle ---
# 'basename "$0"' extrait le nom du fichier du chemin d'appel (ex: de "./script.sh" il garde "script.sh")
SELF_NAME=$(basename "$0")

# --- Début du script ---
echo "Lancement du déploiement de tous les scripts .sh..."
echo "(Le script '$SELF_NAME' sera ignoré)"

# Ajoute une entrée de démarrage dans le fichier log.
echo "--- Session de déploiement démarrée le $(date '+%Y-%m-%d %H:%M:%S') ---" >> "$LOG_FILE"

# Compteur pour vérifier si des fichiers ont été traités.
files_processed=0

# Boucle sur tous les fichiers se terminant par .sh
for script_file in *.sh; do

    # --- AJOUT : Condition pour ignorer le script lui-même ---
    if [ "$script_file" == "$SELF_NAME" ]; then
        continue # 'continue' passe immédiatement à la prochaine itération de la boucle
    fi

    # Cette condition est une sécurité pour le cas où aucun fichier .sh n'est trouvé.
    if [ -f "$script_file" ]; then
        echo "Traitement de : $script_file"

        # 1. Copie du fichier vers le répertoire parent
        cp "$script_file" ../

        # 2. Ajout de la permission d'exécution sur le fichier copié
        chmod +x "../$script_file"

        # 3. Enregistrement de l'action réussie dans le log
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] - DÉPLOYÉ : Le script '$script_file' a été copié et rendu exécutable." >> "$LOG_FILE"
        
        files_processed=$((files_processed + 1))
    fi
done

# --- Fin du script ---
if [ "$files_processed" -eq 0 ]; then
    echo "Aucun fichier .sh trouvé à traiter (autre que le script lui-même)."
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - INFO : Aucun fichier .sh pertinent trouvé pour le déploiement." >> "$LOG_FILE"
else
    echo "✅ Opération terminée. $files_processed script(s) ont été traités."
fi

# Ajoute une entrée de fin dans le fichier log.
echo "--- Session terminée. ---" >> "$LOG_FILE"
echo "Journal des opérations disponible dans le fichier : $LOG_FILE"
