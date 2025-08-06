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
# Script pour nettoyer l'environnement :
# 1. Supprime le dossier source 'git-update-all'.
# 2. Supprime les scripts déployés dans ce répertoire.
# 3. Donne la commande pour s'auto-détruire.
# =========================================================================

# --- Variables de configuration ---
DOSSIER_SOURCE="git-update-all"
# Liste des scripts que 'deploy_all.sh' a copié ici.
# Adaptez cette liste si vous ajoutez/supprimez des scripts.
SCRIPTS_A_NETTOYER=(
    "install_modules.sh"
    "deploy_all.sh"
    "secure_directory.sh"
    "lancer_et_nettoyer.sh" # Ajout des scripts précédents
)

# Nom de ce script, pour ne pas essayer de se supprimer dans la boucle.
CE_SCRIPT=$(basename "$0")

# --- Couleurs ---
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# --- Confirmation ---
echo -e "${RED}⚠️ ATTENTION : Ce script va supprimer définitivement :${NC}"
echo "  - Le dossier source : ${YELLOW}$DOSSIER_SOURCE${NC}"
echo "  - Les scripts déployés listés ci-dessus."
read -p "Êtes-vous absolument sûr de vouloir continuer ? (o/N) " confirmation

if [[ ! "$confirmation" =~ ^([oO][uU][iI]|[oO]|[yY])$ ]]; then
    echo "Opération annulée."
    exit 0
fi

# --- Phase de nettoyage ---
echo "Nettoyage en cours..."

# 1. Suppression du dossier source 'git-update-all'
if [ -d "$DOSSIER_SOURCE" ]; then
    rm -rf "$DOSSIER_SOURCE"
    echo "  - Dossier '$DOSSIER_SOURCE' supprimé."
else
    echo "  - Dossier '$DOSSIER_SOURCE' non trouvé (déjà supprimé ?)."
fi

# 2. Suppression des scripts déployés
for script in "${SCRIPTS_A_NETTOYER[@]}"; do
    if [ -f "$script" ]; then
        rm "$script"
        echo "  - Script '$script' supprimé."
    fi
done

# --- Instructions finales ---
echo -e "\n✅ Nettoyage principal terminé."
echo "Ce script ne peut pas se supprimer lui-même."
echo "Pour finaliser le nettoyage, copiez et exécutez la commande simple ci-dessous :"
echo ""
# Affiche la commande finale à copier-coller. 'rm --' est une sécurité.
echo -e "    ${YELLOW}rm -- \"$CE_SCRIPT\"${NC}"
echo ""