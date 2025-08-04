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

# --- Étape 1: Afficher l'état actuel des branches ---

echo "================================================="
echo "  État actuel des branches des dépôts Git"
echo "================================================="
echo ""

# Boucle pour trouver les dépôts et afficher leur branche
for dir in *; do
    if [ -d "$dir/.git" ]; then
        BRANCH=$(cd "$dir" && git branch --show-current)
        # Affiche le nom du répertoire et la branche, bien alignés
        printf "%-30s -> %s\n" "$dir" "$BRANCH"
    fi
done

echo ""
echo "================================================="
echo ""

# --- Étape 2: Demander confirmation à l'utilisateur ---

read -p "Voulez-vous mettre à jour tous ces dépôts (git pull) ? [y/N] " response

# Convertit la réponse en minuscules pour simplifier la comparaison
response=${response,,}

# --- Étape 3: Agir en fonction de la réponse ---

# Si la réponse est 'y', 'yes', 'o', ou 'oui'
if [[ "$response" =~ ^(y|yes|o|oui)$ ]]; then
    
    echo "Lancement de la mise à jour..."
    
    # Nom du fichier de log
    LOG_FILE="git_update.log"

    # Début de l'écriture dans le log
    echo "=================================================" >> "$LOG_FILE"
    echo "Début de la mise à jour le $(date)" >> "$LOG_FILE"
    echo "=================================================" >> "$LOG_FILE"

    # Boucle pour faire le 'git pull'
    for dir in *; do
        if [ -d "$dir/.git" ]; then
            echo "Mise à jour de : $dir"
            echo "" >> "$LOG_FILE"
            echo "--- Mise à jour de [$dir] ---" >> "$LOG_FILE"
            
            # Exécute git pull et redirige toute la sortie vers le fichier de log
            (cd "$dir" && git pull) >> "$LOG_FILE" 2>&1
        fi
    done

    # Fin de l'écriture dans le log
    echo "=================================================" >> "$LOG_FILE"
    echo "Fin de la mise à jour le $(date)" >> "$LOG_FILE"
    echo "=================================================" >> "$LOG_FILE"

    echo ""
    echo "Mise à jour terminée. Consultez le fichier '$LOG_FILE' pour les détails."

else
    # Si l'utilisateur répond non ou autre chose
    echo "=================================================" >> "$LOG_FILE"
    echo "Opération annulée par l'utilisateur le $(date)" >> "$LOG_FILE"
    echo "=================================================" >> "$LOG_FILE"
    
    echo ""
    echo "Opération annulée par l'utilisateur '$LOG_FILE' pour les détails."
fi

exit 0
