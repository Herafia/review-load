# review-load

Petit outil CLI pour savoir **qui a combien de reviews en attente** sur des PR ouvertes,
afin de mieux répartir les demandes de review dans l'équipe.

```
MEMBRE                    REVIEWS EN ATTENTE
------------------------- ------------------
alice                       4  ####
bob                         2  ##
Herafia                     1  #

Total : 7 review(s) en attente
```

## Installation

Prérequis : [`gh`](https://cli.github.com/) authentifié (`gh auth login`) et `jq`.

```bash
gh api repos/Herafia/review-load/contents/install.sh -H 'Accept: application/vnd.github.raw' | bash
```

Relancer la même commande met l'outil à jour (y compris la liste de l'équipe).

## Utilisation

```bash
review-load -o glpi-project          # tableau par personne
review-load -o glpi-project -d       # + détail des PR de chacun
review-load -r glpi-project/glpi     # limité à un dépôt
review-load --drafts                 # inclut les PR en brouillon
review-load -h                       # aide
```

## Ce qui est compté

- PR **ouvertes** (non mergées, non fermées), hors brouillons et dépôts archivés ;
- demandes de review **nominatives encore en attente** : dès que la personne a soumis
  sa review, la PR ne lui est plus comptée.

## L'équipe

La liste des membres est dans [`team.txt`](team.txt) (un login GitHub par ligne).
Pour ajouter quelqu'un : modifier ce fichier dans le dépôt, puis chacun relance l'installation.

Pour utiliser sa propre liste : `~/.config/review-load/team.txt`, la variable
`REVIEW_LOAD_TEAM`, ou l'option `-t fichier`.
