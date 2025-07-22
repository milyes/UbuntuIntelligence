#!/bin/bash

# Fichiers de stockage
OPTIONS_FILE="ubuntu_custom_options.txt"
DETECTED_COMMANDS="ubuntu_detected_commands.txt"
LOG_FILE="ubuntu_log.txt"

# Vérification et création des fichiers si inexistants
[ ! -f "$OPTIONS_FILE" ] && touch "$OPTIONS_FILE"
[ ! -f "$DETECTED_COMMANDS" ] && touch "$DETECTED_COMMANDS"
[ ! -f "$LOG_FILE" ] && touch "$LOG_FILE"

# Variable pour stocker le dernier résultat
LAST_RESULT=""

# Fonction pour afficher un cadre
afficher_cadre() {
    echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "📌 $1"
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Détection des commandes Ubuntu
detecter_commandes() {
    afficher_cadre "🔍 Détection des commandes Ubuntu"
    ls /usr/bin > "$DETECTED_COMMANDS"
    LAST_RESULT="✅ Commandes détectées et enregistrées."
}

# Fonction pour afficher toutes les options disponibles
afficher_options() {
    afficher_cadre "📂 Liste des commandes disponibles"
    LAST_RESULT="📂 Commandes détectées :\n$(cat -n "$DETECTED_COMMANDS")\n"

    if [ -s "$OPTIONS_FILE" ]; then
        LAST_RESULT+="⭐ Commandes personnalisées :\n$(cat -n "$OPTIONS_FILE")\n"
    else
        LAST_RESULT+="⚠️ Aucune option personnalisée.\n"
    fi
}

# Fonction pour exécuter une commande par saisie
saisie_manuel() {
    read -p "Entrez la commande à exécuter : " commande
    read -p "Confirmer l'exécution de '$commande' ? (o/n) : " confirmation
    if [[ "$confirmation" == "o" || "$confirmation" == "O" ]]; then
        LAST_RESULT="🚀 Exécution de : $commande\n$(eval "$commande" 2>&1)"
        echo -e "\n📝 $(date) - Commande exécutée : $commande" >> "$LOG_FILE"
    else
        LAST_RESULT="❌ Exécution annulée."
    fi
}

# Fonction pour afficher le menu
afficher_menu() {
    clear
    echo -e "🛠️ --- MENU PRINCIPAL ---"
    echo "1️⃣  Détecter les commandes Ubuntu"
    echo "2️⃣  Saisir manuellement une commande"
    echo "3️⃣  Quitter"
    echo -e "\n📌 --- RÉSULTAT ---"
    echo -e "$LAST_RESULT" | less -R
}

# Boucle principale
while true; do
    afficher_menu
    read -p "👉 Choisissez une option : " choix

    case $choix in
        1) detecter_commandes ;;
        2) saisie_manuel ;;
        3) echo "👋 Bye !"; exit 0 ;;
        *) LAST_RESULT="❌ Option invalide !" ;;
    esac
done
