import feedparser
from datetime import datetime
import os

# Obtenir la date d'aujourd'hui
aujourd_hui = datetime.now().strftime("%Y%m%d")

# Créer le répertoire avec le nom de la date d'aujourd'hui
output_dir = f"/root/trainfobel/stats/{aujourd_hui}"
os.makedirs(output_dir, exist_ok=True)

rss_url = "****"
feed = feedparser.parse(rss_url)

for entry in feed.entries:
    title = entry.title

    # Utiliser l'horodatage comme nom de fichier
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S%f")
    filename = f"{output_dir}/{timestamp}.txt"

    # Écrire le titre dans un fichier texte
    with open(filename, "w", encoding="utf-8") as file:
        file.write(title)
