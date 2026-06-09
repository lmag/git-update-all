#!/bin/bash
# Copyright (C) 2025  Laurent Magnin
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.

LOG_FILE="git_update.log"
CSV_FILE="list-repo-to-clone.csv"

echo "================================================="
echo "  Mise à jour des forks depuis l'upstream"
echo "================================================="
echo ""

if [ ! -f "$CSV_FILE" ]; then
    echo "ERREUR : Le fichier '$CSV_FILE' est introuvable."
    echo "Assurez-vous d'avoir exécuté 10_deploy_all.sh ou d'être dans le bon répertoire."
    echo ""
    exit 1
fi

read -p "Voulez-vous mettre à jour tous vos forks configurés dans le CSV depuis leur upstream ? [y/N] " response
response=${response,,}

if [[ "$response" =~ ^(y|yes|o|oui)$ ]]; then
    
    echo "Lancement de la mise à jour..."
    
    echo "=================================================" >> "$LOG_FILE"
    echo "Début de la mise à jour depuis l'upstream le $(date)" >> "$LOG_FILE"
    echo "=================================================" >> "$LOG_FILE"

    tail -n +2 "$CSV_FILE" | while IFS=, read -r org url_upstream branch url_fork dossier toclone; do
        # Supprime les guillemets éventuels
        url_upstream=$(echo "$url_upstream" | tr -d '"' | tr -d '\r')
        dossier=$(echo "$dossier" | tr -d '"' | tr -d '\r')
        
        if [ -n "$dossier" ] && [ -d "$dossier/.git" ]; then
            echo "Mise à jour de : $dossier"
            echo "" >> "$LOG_FILE"
            echo "--- Mise à jour de [$dossier] depuis l'upstream ---" >> "$LOG_FILE"
            
            (
                cd "$dossier" || exit
                
                # Ajoute ou met à jour le remote upstream
                if git remote get-url upstream >/dev/null 2>&1; then
                    git remote set-url upstream "$url_upstream" >> "../$LOG_FILE" 2>&1
                else
                    git remote add upstream "$url_upstream" >> "../$LOG_FILE" 2>&1
                fi
                
                CURRENT_BRANCH=$(git branch --show-current)
                
                echo "  -> Branche courante : $CURRENT_BRANCH"
                echo "  -> Upstream : $url_upstream"
                
                echo "  -> Pull depuis upstream..."
                # Pull depuis upstream
                git pull upstream "$CURRENT_BRANCH" 2>&1 | tee -a "../$LOG_FILE"
                echo "" >> "../$LOG_FILE"
                
                echo "  -> Push vers origin..."
                # Push vers origin (fork)
                git push origin "$CURRENT_BRANCH" 2>&1 | tee -a "../$LOG_FILE"
                echo "" >> "../$LOG_FILE"
            )
        elif [ -n "$dossier" ]; then
            echo "  -> $dossier ignoré (non cloné ou pas un dépôt Git)."
        fi
    done

    echo "=================================================" >> "$LOG_FILE"
    echo "Fin de la mise à jour depuis l'upstream le $(date)" >> "$LOG_FILE"
    echo "=================================================" >> "$LOG_FILE"

    echo ""
    echo "✅ Mise à jour depuis upstream terminée. Consultez le fichier '$LOG_FILE' pour les détails."

else
    echo "Opération annulée par l'utilisateur."
    
    echo "" >> "$LOG_FILE"
    echo "=================================================" >> "$LOG_FILE"
    echo "Opération annulée par l'utilisateur le $(date)" >> "$LOG_FILE"
    echo "=================================================" >> "$LOG_FILE"
fi

echo ""
read -p "Appuyez sur Entrée pour continuer..."

exit 0
