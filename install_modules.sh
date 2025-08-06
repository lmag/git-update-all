
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

#!/bin/bash

#!/bin/bash

#================================================================
# Script pour cloner les modules Evarisk et Eoxia depuis GitHub
# avec confirmation pour chaque module individuel.
#================================================================

# --- Couleurs pour les messages ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Pas de couleur

# --- Vérification de la présence de 'git' ---
if ! command -v git &> /dev/null
then
    echo -e "${RED}ERREUR : 'git' n'est pas installé.${NC}"
    echo -e "${YELLOW}Veuillez installer git pour continuer (ex: sudo apt install git).${NC}"
    exit 1
fi

echo -e "${GREEN}L'outil 'git' est bien installé. Démarrage du script...${NC}\n"

#===========================
# Modules Evarisk
#===========================
read -p "Souhaitez-vous parcourir la liste des modules Evarisk ? (o/N) " response
if [[ "$response" =~ ^([oO][uU][iI]|[oO]|[yY][eE][sS]|[yY])$ ]]
then
    echo -e "\n${YELLOW}--- Sélection des modules Evarisk ---${NC}"

    declare -A evarisk_repos=(
        ["https://github.com/Evarisk/Digirisk"]="digiriskdolibarr"
        ["https://github.com/Evarisk/Saturne"]="saturne"
        ["https://github.com/Evarisk/dolicar"]="dolicar"
        ["https://github.com/Evarisk/dolimeet"]="dolimeet"
        ["https://github.com/Evarisk/digiboard"]="digiboard"
        ["https://github.com/Evarisk/DoliSecu"]="dolisecu"
        ["https://github.com/Evarisk/gmao"]="gmao"
    )

    for repo_url in "${!evarisk_repos[@]}"
    do
        dir_name="${evarisk_repos[$repo_url]}"
        
        # --- CORRECTION : Utilisation de 'echo -e' pour l'affichage ---
        echo # Ligne vide pour une meilleure lisibilité
        echo -e "Voulez-vous installer le module suivant ?
  -> Dépôt      : ${YELLOW}${repo_url}${NC}
  -> Destination : ${YELLOW}${dir_name}${NC}"
        read -p "   (o/N) " install_confirm

        if [[ "$install_confirm" =~ ^([oO][uU][iI]|[oO]|[yY][eE][sS]|[yY])$ ]]; then
            echo -e "Clonage en cours..."
            if git clone "$repo_url" "$dir_name"; then
                echo -e "${GREEN}Succès !${NC}"
            else
                echo -e "${RED}ERREUR lors du clonage de ${repo_url}. Le dossier existe peut-être déjà.${NC}"
            fi
        else
            echo -e "${YELLOW}Module ignoré.${NC}"
        fi
        echo "-----------------------------------------------------"
    done
    echo -e "\n${GREEN}--- Fin de la sélection des modules Evarisk ---${NC}"
else
    echo -e "${YELLOW}Installation des modules Evarisk entièrement ignorée.${NC}"
fi

#===========================
# Modules Eoxia
#===========================
read -p $'\n'"Souhaitez-vous parcourir la liste des modules Eoxia ? (o/N) " response
if [[ "$response" =~ ^([oO][uU][iI]|[oO]|[yY][eE][sS]|[yY])$ ]]
then
    echo -e "\n${YELLOW}--- Sélection des modules Eoxia ---${NC}"

    declare -A eoxia_repos=(
        ["https://github.com/Eoxia/WPshop"]="WPshop"
        ["https://github.com/Eoxia/easycrm"]="easycrm"
        ["https://github.com/Eoxia/priseo"]="priseo"
        ["https://github.com/Eoxia/EasyURL"]="EasyURL"
    )

    for repo_url in "${!eoxia_repos[@]}"
    do
        dir_name="${eoxia_repos[$repo_url]}"
        
        # --- CORRECTION : Utilisation de 'echo -e' pour l'affichage ---
        echo
        echo -e "Voulez-vous installer le module suivant ?
  -> Dépôt      : ${YELLOW}${repo_url}${NC}
  -> Destination : ${YELLOW}${dir_name}${NC}"
        read -p "   (o/N) " install_confirm

        if [[ "$install_confirm" =~ ^([oO][uU][iI]|[oO]|[yY][eE][sS]|[yY])$ ]]; then
            echo -e "Clonage en cours..."
            if git clone "$repo_url" "$dir_name"; then
                echo -e "${GREEN}Succès !${NC}"
            else
                echo -e "${RED}ERREUR lors du clonage de ${repo_url}. Le dossier existe peut-être déjà.${NC}"
            fi
        else
            echo -e "${YELLOW}Module ignoré.${NC}"
        fi
        echo "-----------------------------------------------------"
    done
    echo -e "\n${GREEN}--- Fin de la sélection des modules Eoxia ---${NC}"
else
    echo -e "${YELLOW}Installation des modules Eoxia entièrement ignorée.${NC}"
fi

echo -e "\n${GREEN}Script terminé !${NC} 👋\n"