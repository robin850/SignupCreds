# SignupCreds - Application mobile

Cette application a été créée dans le cadre du module **Compilation et développement d'applications mobiles** par :

- Samuel Bazniar
- Thomas Delhaye
- Robin Dupret

L'application permet de parser un fichier JSON et de générer un formulaire dynamique en fonction du service sélectionné, afin de sauvegarder les utilisateurs dans la mémoire du téléphone.

## Quelques informations

### Première vue : Choix du service

La première vue permet de choisir le service auquel vous souhaitez souscrire. Les services s'affichent sous forme de Card, et sont générés depuis le fichier `service.json`. 
Une fois le service sélectionné, l'application vous renvoie sur la vue `Formulaire`.

### Deuxième vue : Formulaire

Le formulaire est généré dynamiquement en fonction du service choisi. Chaque champ est généré grâce au fichier `service.json`.
En cliquant sur `Enregistrer`, vous serez redirigé sur la vue `Nos membres`.
> Si aucun service n'est sélectionné, un message indique qu'il faut en choisir un.

### Troisième vue : Nos membres

Ici, tous les membres du service sélectionné sont affichés. 
> Si aucun service n'est sélectionné, un message indique qu'il faut en choisir un.
> Si il n'y a aucun membre pour ce service, un message indique qu'il faut en créer un grâce au formulaire.

### Quatrième vue : À propos

Vous retrouverez ici les 3 concepteurs de l'application, ainsi qu'un bouton de suppression des membres pour le service sélectionné.

### Le bouton `?` sur chaque vue

Ce bouton permet d'afficher des informations système, comme la mémoire RAM utilisée, la mémoire ROM restante et totale, et le pourcentage d'utilisation du CPU consommée par l'application.

> Le pourcentage d'utilisation du CPU présent dans le popup met un peu de temps à s'initialiser au démarrage de l'application. Il faut patienter quelques instants afin que le premier calcul se fasse !
