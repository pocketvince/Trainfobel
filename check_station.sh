#!/bin/bash
temps=$(date "+%Y%m%d%H%M%S")
# Chemin vers le fichier contenant la liste d'arguments
fichier_arguments="station_name.txt"
# Chemin vers le fichier texte à vérifier
fichier_texte="$1"
# Liste des mots à exclure (articles, conjonctions, prépositions, etc.)
mots_exclus=(" - " "le" "la" "les" "un" "une" "des" "du" "de" "au" "aux" "en" "pour" "avec" "par" "sur" "dans" "vers" "depuis" "jusqu'à" "sans" "sous" "chez" "mais" "et" "ou" "donc" "or" "ni" "car" "que" "qui" "quoi" "où" "quand" "comment" "pourquoi" "tant" "tellement" "trop" "très" "peu" "plus" "moins" "autant" "aussi" "bien" "malgré" "sauf" "excepté" "hors" "pendant" "à" "d'" "l'" "ce" "cet" "cette" "ces" "ceux" "celui" "celle" "ceux-ci" "celles-ci" "ceux-là" "celles-là" "ceci" "cela" "travaux" "Le" "La" "Les" "Un" "Une" "Des" "Du" "De" "Au" "Aux" "En" "Pour" "Avec" "Par" "Sur" "Dans" "Vers" "Depuis" "Jusqu'à" "Sans" "Sous" "Chez" "Mais" "Et" "Ou" "Donc" "Or" "Ni" "Car" "Que" "Qui" "Quoi" "Où" "Quand" "Comment" "Pourquoi" "Tant" "Tellement" "Trop" "Très" "Peu" "Plus" "Moins" "Autant" "Aussi" "Bien" "Malgré" "Sauf" "Excepté" "Hors" "Pendant" "À" "D'" "L'" "Ce" "Cet" "Cette" "Ces" "Ceux" "Celui" "Celle" "Ceux-ci" "Celles-ci" "Ceux-là" "Celles-là" "Ceci" "Cela" "Travaux" "bus" "Bus")
# Lire les arguments du fichier
arguments=$(cat "$fichier_arguments")
# Lire le contenu du fichier texte
contenu=$(cat "$fichier_texte")
arguments_trouves=""
for argument in $arguments; do
# Vérifier si l'argument est un mot à exclure
mot_exclu=0
for mot_exclu in "${mots_exclus[@]}"; do
if [[ "$argument" == "$mot_exclu" ]]; then
mot_exclu=1
break
fi
done
# Rechercher l'argument uniquement s'il n'est pas un mot à exclure
if [[ $mot_exclu -eq 0 ]] && grep -w "$argument" <<< "$contenu" >/dev/null; then
arguments_trouves+="$argument "
fi
done
echo "$temps" >> log.txt
if [[ -n $arguments_trouves ]]; then
echo "$temps - Arguments trouvés: $arguments_trouves" >> log.txt
echo "$temps - Tweet: $1" >> log.txt
python3 tweet.py "$1" >> log.txt
sleep 60
else
  echo "$1 ne sera pas publié"
echo "$temps: Tweet: $1 (pas publié)" >> log.txt
fi
echo "$temps - stop" >> log.txt
