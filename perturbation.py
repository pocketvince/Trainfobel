import feedparser
from datetime import datetime
from bs4 import BeautifulSoup

rss_url = "****"
feed = feedparser.parse(rss_url)

for entry in feed.entries:
    title = entry.title
    content = entry.summary

    # Utilisez l'horodatage comme nom de fichier
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S%f")
    filename = f"perturbation/{timestamp}.txt"

    # Supprimez les balises HTML du contenu de la nouvelle
    soup = BeautifulSoup(content, "html.parser")
    clean_content = soup.get_text()

    # Ajoutez un interligne après chaque point
    clean_content = clean_content.replace(".", ".\n")

    # Retirez les espaces superflus
    clean_content = clean_content.strip()

    # Écrivez le contenu nettoyé dans un fichier texte
    with open(filename, "w", encoding="utf-8") as file:
        file.write(clean_content)
