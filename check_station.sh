#!/bin/bash
# Chemin vers le fichier contenant la liste d'arguments
fichier_arguments="gare.txt"
# Chemin vers le fichier texte à vérifier
fichier_texte="$1"
# Liste des mots à exclure (articles, conjonctions, prépositions, etc.)
mots_exclus=("le" "la" "les" "un" "une" "des" "du" "de" "au" "aux" "en" "pour" "avec" "par" "sur" "dans" "vers" "depuis" "jusqu'à" "sans" "sous" "chez" "mais" "et" "ou" "donc" "or" "ni" "car" "que" "qui" "quoi" "où" "quand" "comment" "pourquoi" "tant" "tellement" "trop" "très" "peu" "plus" "moins" "autant" "aussi" "bien" "malgré" "sauf" "excepté" "hors" "pendant" "à" "d'" "l'" "ce" "cet" "cette" "ces" "ceux" "celui" "celle" "ceux-ci" "celles-ci" "ceux-là" "celles-là" "ceci" "cela" "travaux")
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

if [[ -n $arguments_trouves ]]; then
python3 tweet.py "$1"
sleep 300
else
  echo "$1 ne sera pas publié"
fi
