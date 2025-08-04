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

# Nom du fichier de log
LOG_FILE="git_update.log"

# Affiche le début de l'exécution dans le log avec la date et l'heure
echo "=================================================" >> "$LOG_FILE"
echo "Début de la mise à jour des dépôts le $(date)" >> "$LOG_FILE"
echo "=================================================" >> "$LOG_FILE"

# Boucle sur chaque élément (fichier ou répertoire) du dossier courant
for dir in *; do
    # Vérifie si l'élément est un répertoire ET s'il contient un sous-répertoire .git
    if [ -d "$dir/.git" ]; then
        echo "Update : $dir"
        
        # Écrit le nom du répertoire en cours de traitement dans le log
        echo "" >> "$LOG_FILE"
        echo "--- Update [$dir] ---" >> "$LOG_FILE"
        
        # Se place dans le répertoire, exécute git pull, et redirige la sortie (stdout et stderr) vers le log
        # L'utilisation de ( ... ) crée un subshell, évitant d'avoir à faire 'cd ..'
        (cd "$dir" && git pull) >> "$LOG_FILE" 2>&1
        
        echo "Done."
    fi
done

echo "=================================================" >> "$LOG_FILE"
echo "Fin de la mise à jour le $(date)" >> "$LOG_FILE"
echo "=================================================" >> "$LOG_FILE"

echo ""
echo "Update Done. See '$LOG_FILE' for details."