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

# =========================================================================
# Script pour nettoyer l'environnement de manière sécurisée :
# 1. Analyse les éléments à supprimer.
# 2. Affiche la liste des actions réelles et demande confirmation.
# 3. Exécute la suppression et donne la commande d'auto-destruction.
# =========================================================================

# --- Variables de configuration ---
DOSSIER_SOURCE="git-update-all"
SCRIPTS_A_NETTOYER=(
    "git-update-all.sh"
    "install_modules.sh"
    "update_git_all.sh"
)
CE_SCRIPT=$(basename "$0")

# --- Couleurs ---
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# --- 1. Phase d'analyse ---
echo "Analyse des éléments à nettoyer..."
# On crée un tableau pour stocker les actions qui seront réellement effectuées.
declare -a actions_a_faire=()

# On vérifie si le dossier source existe.
if [ -d "$DOSSIER_SOURCE" ]; then
    actions_a_faire+=("rm -rf ${DOSSIER_SOURCE}")
fi

# On vérifie pour chaque script s'il existe.
for script in "${SCRIPTS_A_NETTOYER[@]}"; do
    if [ -f "$script" ]; then
        actions_a_faire+=("rm ${script}")
    fi
done

# --- 2. Phase de confirmation ---
# S'il n'y a aucune action à faire, on quitte.
if [ ${#actions_a_faire[@]} -eq 0 ]; then
    echo "✅ Tout est déjà propre. Aucune action n'est nécessaire."
    echo "Il ne reste que ce script. Pour le supprimer, utilisez la commande :"
    echo -e "    ${YELLOW}rm -- \"$CE_SCRIPT\"${NC}"
    exit 0
fi

echo -e "\n${RED}⚠️ ATTENTION : Après confirmation, les commandes suivantes seront exécutées :${NC}"
# On affiche chaque commande qui sera lancée.
for cmd in "${actions_a_faire[@]}"; do
    echo -e "  - ${YELLOW}${cmd}${NC}"
done

echo "" # Ligne vide
read -p "Êtes-vous absolument sûr de vouloir continuer ? (o/N) " confirmation

if [[ ! "$confirmation" =~ ^([oO][uU][iI]|[oO]|[yY])$ ]]; then
    echo "Opération annulée."
    exit 0
fi

# --- 3. Phase d'exécution ---
echo "Exécution du nettoyage..."
for cmd in "${actions_a_faire[@]}"; do
    eval $cmd # 'eval' exécute la commande stockée dans la variable
    echo "  - Commande exécutée : '$cmd'"
done

# --- 4. Instructions finales ---
echo -e "\n✅ Nettoyage principal terminé."
echo "Ce script ne peut pas se supprimer lui-même."
echo "Pour finaliser, copiez et exécutez la commande simple ci-dessous :"
echo ""
echo -e "    ${YELLOW}rm -- \"$CE_SCRIPT\"${NC}"
echo ""