#!/bin/bash
#Securite pour le cron, aller dans le dossier de trainfobel
cd /root/trainfobel
####Perturbation
#recherche de perturbation ou travaux
mkdir -p perturbation
python3 perturbation.py
#reduction fichier texte
date=$(date +"%Y%m%d")
repertoire="/root/trainfobel/perturbation"
argument_file="reduce_argument.txt"
file=$(date "+%Y%m%d%H%M%S")
#quik fix for ".:" to ": "
find /root/trainfobel/perturbation/ -type f -name "*.txt" -exec sed -i 's/\.:/: /g' {} +
echo "$file - start" >> log.txt
fichier_md5="/root/trainfobel/md5sum_data.txt"

for file in "$repertoire"/*.txt; do
    if [ -e "$file" ]; then
        arguments=$(cat "$argument_file")
        while IFS= read -r argument; do
            sed -i "s/$argument.*//g" "$file"
        done <<< "$arguments"
    fi
done
#nettoyage espace superflu
for fichier in "$repertoire"/*.txt; do
    # Vérifier si le fichier est un fichier texte
    if [[ $fichier == *.txt ]]; then
        # Supprimer les espaces superflus dans le fichier
        tr -s ' ' < "$fichier" > "$fichier.tmp"
        mv "$fichier.tmp" "$fichier"
    fi
done
#Nettoyer interligne superflu
for file in "$repertoire"/*.txt; do
awk 'NF > 0 { print }' "$file" > "tmp_file" ; rm "$file" ; mv "tmp_file" "$file"
done
#Ajouter hashtag sncb
for fichier in "$repertoire"/*.txt; do
    if [ -w "$fichier" ]; then
        # Vérifier si le fichier se termine déjà par "#sncb"
        if grep -qE '#sncb$' "$fichier"; then
            echo "Le fichier $fichier se termine déjà par #sncb. Pas de modification nécessaire."
else
            # Vérifier la longueur du fichier
            longueur=$(wc -c < "$fichier")
            if [ $longueur -le 273 ]; then
                # Ajouter "#sncb" à la fin du fichier
                echo " #sncb" >> "$fichier"
                echo "La modification a été effectuée pour le fichier : $fichier"
            else
                # Tronquer le fichier pour conserver les 270 premiers caractères et ajouter "...#sncb"
                contenu=$(head -c 270 "$fichier")
                echo "$contenu... #sncb" > "$fichier"
                echo "La modification a été effectuée pour le fichier : $fichier"
            fi
        fi
    else
        echo "Impossible de modifier le fichier : $fichier"
    fi
done
#creation du script de publication
#Fonction md5
calculer_md5sum() {
    md5sum "$1" | awk '{print $1}'
}
# Liste des fichiers texte du repertoire
fichiers_texte=("$repertoire"/*.txt)
# Liste des MD5 déjà présents dans le fichier md5sum_data.txt
md5_existant=()
if [ -f "$fichier_md5" ]; then
md5_existant=($(< "$fichier_md5"))
fi
# Liste des fichiers à supprimer
fichiers_a_supprimer=()
# Liste des commandes à ajouter dans tempo.sh
commandes_tempo=()
# Parcourir les fichiers texte
for fichier in "${fichiers_texte[@]}"; do
 # Calcul du MD5 du fichier
md5=$(calculer_md5sum "$fichier")
if [[ " ${md5_existant[@]} " =~ " ${md5} " ]]; then
# MD5 déjà présent, ajouter le fichier à la liste des fichiers à supprimer
fichiers_a_supprimer+=("$fichier")
else
# MD5 non présent, ajouter la commande à la liste des commandes pour tempo.sh
commande_tempo="./check_station.sh $repertoire/$(basename "$fichier")"
commandes_tempo+=("$commande_tempo")
# Ajouter le MD5 au fichier md5sum_data.txt
echo "$md5" >> "$fichier_md5"
fi
done
# Supprimer les fichiers avec des MD5 déjà existants
for fichier in "${fichiers_a_supprimer[@]}"; do
rm "$fichier"
done
#Retirer les doublons
sort "$fichier_md5" | uniq > temp_md ; rm "$fichier_md5" ; mv temp_md "$fichier_md5"

# Ajouter les commandes dans tempo.sh uniquement si nous sommes entre 4h et 23h
heure_actuelle=$(date +%H)
if [[ heure_actuelle -ge 4 && heure_actuelle -lt 23 ]]; then
echo "#!/bin/bash" > "$date-tempo.sh"
echo "echo Start tempo" >> "$date-tempo.sh"
printf "%s\n" "${commandes_tempo[@]}" >> "$date-tempo.sh"
echo "echo End tempo" >> "$date-tempo.sh"
chmod +x "$date-tempo.sh"
./$date-tempo.sh
rm "$date-tempo.sh"
fi

####Stats
directory="/root/trainfobel/stats/$date"
mkdir -p /root/trainfobel/stats
mkdir -p /root/trainfobel/stats/$date
python3 stats.py
# Tableau pour stocker les MD5 des fichiers
declare -A md5_array

# Parcourir les fichiers texte dans le dossier
find "$directory" -type f -name "*.txt" | while read -r file_path; do
# Calculer la valeur MD5 du fichier
md5=$(md5sum "$file_path" | awk '{print $1}')
# Vérifier si le MD5 existe déjà dans le tableau
    if [[ ${md5_array[$md5]} ]]; then
        # Supprimer la copie du fichier
        rm "$file_path"
        echo "Fichier supprimé : $file_path"
    else
        # Ajouter le MD5 au tableau
        md5_array[$md5]=1
    fi
done

####Fin du script
echo execution $SECONDS seconds
