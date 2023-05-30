# -*- coding: utf8 -*-
import sys
import tweepy

# Récupérer les arguments de ligne de commande
fichier_texte = sys.argv[1]

# Configuration de l'API Twitter
consumer_key = '****'
consumer_secret = '****'
access_token = '*****'
access_token_secret = '****'

# Authentification auprès de l'API Twitter
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth)

# Ouvrir et lire le fichier texte
with open(fichier_texte, 'r') as fichier:
    contenu = fichier.read()

# Tweeter le contenu du fichier
api.update_status(contenu)

print('Tweet envoyé !')
