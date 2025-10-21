Test de la fonctionnalité RM

1) Préparer le fichier de test

Remplir `~/.config/ShazamClean/rm_cleaning_list.txt` (ou copier `tests/rm_test.txt` pour essais) :

```sh
cp tests/rm_test.txt ~/.config/ShazamClean/rm_cleaning_list.txt
```

2) Dry-run (simulation)

Lance le script principal :

```sh
./ShazamClean.sh
```

Le script affiche par défaut une liste (dry-run) des fichiers/répertoires qui seraient supprimés. Il demande ensuite confirmation avant la suppression réelle.

3) Test manuel

- Crée un dossier et un fichier de test :

```sh
mkdir -p "$HOME/.tmp_test_rm_dir"
touch "$HOME/.tmp_test_rm_file.txt"
```

- Assure-toi que `~/.config/ShazamClean/rm_cleaning_list.txt` contient ces chemins (relatifs) puis relance `./ShazamClean.sh`.

4) Vérifier le journal

Le log des suppressions est écrit dans :

```
~/.config/ShazamClean/rm_cleaning_list.log
```

Remarques de sécurité

- Les chemins résolus situés en dehors de `$HOME` sont ignorés (protection).
- Si `gio` ou `trash-put` est disponible, la corbeille est privilégiée ; sinon le script utilise `rm -rf`.
- Par défaut le script fait une passe d'affichage (dry-run) ; la suppression réelle demande confirmation (sauf si exécutée avec le flag `force`).

---

Voir `README.md` pour le fonctionnement global du script.
