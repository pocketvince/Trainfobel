#!/bin/bash
yesterday=$(date -d "yesterday" +"%Y%m%d")
hier=$(date -d "yesterday" +"%d/%m/%Y")
repertoire=/root/trainfobel/stats/$yesterday
repertoire_racine=/root/trainfobel/
cd $repertoire
# Effectue le grep sur le signe ":" pour ne récupérer que les fichiers contenant ":"
files=$(grep ":" *)

# Initialise un tableau associatif pour stocker les occurrences
declare -A occurrences

# Parcourt les fichiers et extrait le texte après le ":"
while IFS=':' read -r file content; do
    # Supprime les espaces en début et fin de chaîne
    content=$(echo "$content" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    # Supprime le nom de la gare s'il est présent
    content=$(echo "$content" | cut -d ':' -f 2-)

    # Supprime le point à la fin de la chaîne
    content=${content%.}

    # Vérifie si le contenu n'est pas vide après les modifications
    if [[ -n "$content" ]]; then
        # Incrémente le compteur d'occurrences
        ((occurrences[$content]++))
    fi
done <<< "$files"

# Affiche les résultats
echo "Trainfostats ($hier):" > $repertoire_racine/report_$yesterday.txt
for content in "${!occurrences[@]}"; do
    echo "🟠 $content: ${occurrences[$content]}">> $repertoire_racine/report_$yesterday.txt
done
echo "" >> $repertoire_racine/report_$yesterday.txt
echo "⚠️Peut contenir des erreurs" >> $repertoire_racine/report_$yesterday.txt
echo '#sncb #trainfobel' >> $repertoire_racine/report_$yesterday.txt
cd $repertoire_racine
python3 tweet.py report_$yesterday.txt

