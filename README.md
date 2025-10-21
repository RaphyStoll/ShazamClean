# ShazamClean

Script simple pour libérer de l'espace sur les sessions Linux (ex: 42Lausanne).

## Exécution à distance

Pour télécharger et exécuter directement le script depuis ce dépôt :

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/RaphyStoll/ShazamClean/main/ShazamClean.sh)"
```

## Installation

Le script d'installation crée un alias `42clean` dans `~/.zshrc` et `~/.bashrc`.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/RaphyStoll/ShazamClean/main/install.sh)"
```

## Exécution

Après l'installation :

```sh
42clean
```

Ou lance directement le script du dépôt :

```sh
./ShazamClean.sh
```

## Désinstallation

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/RaphyStoll/ShazamClean/main/uninstall.sh)"
```

## Ajouter des répertoires à nettoyer

Ajoute chaque répertoire (une entrée par ligne) dans : `~/.config/ShazamClean/cleaning_list.txt`.

Remarques :
- Les chemins listés sont interprétés comme relatifs à `$HOME` (par ex. `/.cache` devient `$HOME/.cache`) à moins d'être fournis en absolu.
- WARNING: le nettoyage des répertoires supprime leur contenu sans confirmation. Sois prudent avec ce que tu ajoutes.

## Fichier de suppression définitive (`rm_cleaning_list.txt`)

Un fichier séparé `~/.config/ShazamClean/rm_cleaning_list.txt` peut être utilisé pour lister des fichiers et répertoires à supprimer définitivement (pas seulement vider). Le script affiche d'abord un dry-run (liste) et demande confirmation avant suppression réelle.

- Par sécurité, les chemins situés en dehors de `$HOME` sont ignorés.
- Si `gio` ou `trash-put` est disponible la corbeille est utilisée ; sinon le script retombe sur `rm -rf`.
- Les suppressions sont journalisées dans `~/.config/ShazamClean/rm_cleaning_list.log`.

Consulte `README_RM.md` pour des instructions de test et de sécurité supplémentaires.
