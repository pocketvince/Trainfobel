#!/bin/bash
#Securite pour le cron, aller dans le dossier de trainfobel
cd /root/trainfobel
#recherche de perturbation ou travaux
python3 perturbation.py
#nettoyage txt file
repertoire="/root/trainfobel/perturbation"
for fichier in "$repertoire"/*.txt; do
    # Vérifier si le fichier existe et est accessible en écriture
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
file=$(date "+%Y%m%d%H%M%S")
echo "#!/bin/bash" > tempo.sh
echo "Log tempo_file.sh - $file"
md5sum /root/trainfobel/perturbation/*.txt | sort | uniq -u -w32 | cut -c 35- | sed 's/^/.\/check_station.sh /' >> "tempo.sh"
md5sum /root/trainfobel/perturbation/*.txt | sort | uniq -u -w32 | cut -c 35- | while read -r file; do
    cp "$file" "${file}_1.txt"
done
chmod +x tempo.sh
./tempo.sh
rm tempo.sh
sleep 600
exec $0
