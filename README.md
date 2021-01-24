# TTExoMind

Test Exomind

Vous développerez une application universelle (smartphone et tablette) avec trois écrans :
- La liste des utilisateurs (nom, pseudo, mail, tel, site) avec une barre de recherche 
- La liste des albums pour un utilisateur
- La liste des photos d’un album

L’API a utiliser:
Récupérer la liste des utilisateurs -> https://jsonplaceholder.typicode.com/users
Albums d’un utilisateur -> https://jsonplaceholder.typicode.com/users/{userID}/albums
Photos d’un album -> https://jsonplaceholder.typicode.com/users/{userID}/photos?albumId={albumID}

Les données téléchargées devront être disponible offline.
Une fois les albums/photos d’un utilisateur récupérés ne plus refaire l’appel à l'API

Vous pouvez utiliser des librairies externes si vous le jugez vraiment nécessaire.
Le projet devra être disponible sur un répertoire GIT que l’on pourra consulter.

Ce que nous observerons dans l'exercice :
- La qualité / lisibilité du code. 
- L'architecture, les patterns utilisés. 
- Respects des standards de code
- La pertinence des commits.
- Les tests automatiques (unitaires, UI)
