# SaveSystem

Système de sauvegarde autonome pour Linux (testé sous Debian GNU/Linux 8.5 (jessie))

---
### Langages utilisés
SaveSystem utilise un seul et unique language :
    - Shell (100%)

---
### Version
0.1.0

Bien sûr ce Système de sauvegarde est open source avec un [dépôt public][save] sur GitHub.

---
### Installation

---
#### Récupérer les sources :
Pour récupérer les sources :
```sh
$ cd ~/
$ git clone https://github.com/RootKitDev/SaveSystem.git SaveSystem
```

---
### Utilisation

---
#### Fonctionnement Général
SaveSystem fonctionne actuellement sur le serveur à sauvegarde et le script est concu pour être
execute au moins une fois par jour.

SaveSystem effectue, avec un ordre arbitraire de priorité, les sauvegardes suivante:
    - Mensuel (Full : e.g sauvegarde full du systeme ),
    - Hebdomadiare (Full : e.g sauvegarde full des données utilisateur/applicatives),
    - Week-End (Incrémentiel de la Mensuel : e.g chaque Samedi),
    - SQL (Full des BDDs : e.g chaque Dimanche),
    - Journaliere (Incrémentiel de la Hebdomadiare : c'est le traitement par défaut si aucune autre sauvegardes n'ont pas déclenché)

SaveSystem intégre un systeme de "Fanions" dans ```sh /path/to/my/SaveSystem/Flags ```, qui permet la gestion des sauvegardes.
Les Fanions sont par défault "rangés" dans ```sh /path/to/my/SaveSystem/Flags/Block ```, afin qui le SaveSystem n'interprete pas les fanions par "erreur".

La liste des Fanions : 
ATTENTTION : Les fanions PS sont arbitrairement prioritaire.
    - EX-000 ("Sauvegarde Exceptionnel" : execute une sauvegarde Mensuel hors dans la condition par défault (chaque 1er du mois)),
    - PS-000 ("Pas de Sauvegarde" (Super "Pas de Sauvegarde") : empeche tous type de sauvegarde (sans pour autant indiquer qu'il n'y a pas eu de sauvegarde), pour laisser les sauvegardes SQL s'effectuer),
    - PS-001 ("Pas de Sauvegarde Mensuel/Exceptionnel" : historise dans les logs le "Pas de Sauvegarde"),
    - PS-002 ("Pas de Sauvegarde Hebdomadiare" : historise dans les logs le "Pas de Sauvegarde"),
    - PS-003 ("Pas de Sauvegarde Week-End" : historise dans les logs le "Pas de Sauvegarde"),
    - PS-004 ("Pas de Sauvegarde Journaliere" : historise dans les logs le "Pas de Sauvegarde")

L'utilisation automatique de ce systeme nécessite crontab (ou tout autre planificateur de tâches)
voici un exemple de règle crontab 

```sh
# Lancement du script de sauvegarde data (Data_Save.sh) tous les jour à 6h
00 6 * * * /path/to/my/SaveSystem/Data_Save.sh >> /path/to/my/SaveSystem/Logs.d/Cron.log 2>&1 
```

Le systeme actuel nécessite un hôte de reception, pour l'externalisation les sauvegardes.

---
### Git Lié
Une IHM (Interface Homme-Machine) web est en cours de dévelopement intégrant, affichage des logs de la sauvegarde demandé, affichage de CkeckSum et de volumétrie
Le [dépôt public][ihm] de l'IHM_SaveSystem

---
### Contribution

Vous voulez contribuer ? Très bien !

Envoyez-moi vos idées et commentaires par mail : <rootkit.dev@gmail.com>.

---
### Licence

MIT

**Free Software, Hell Yeah!**

---

[save]: <https://github.com/RootKitDev/SaveSystem>
[ihm]: <https://github.com/RootKitDev/IHM_SaveSystem>