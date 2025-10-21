Test de la fonctionnalité RM

1) Remplir `~/.config/ShazamClean/rm_cleaning_list.txt` (ou utiliser `tests/rm_test.txt` pour essais).

2) Dry-run (simulate) — lance le script et il affichera les fichiers qui seraient supprimés :

   ./ShazamClean.sh

   Le script éxécute par défaut un dry-run pour le fichier RM et demande confirmation avant suppression réelle.

3) Pour tester manuellement :
   - Crée un dossier ~/ .tmp_test_rm_dir et un fichier ~/.tmp_test_rm_file.txt
   - Assure-toi que `rm_cleaning_list.txt` contient ces chemins (relatifs), puis lance `./ShazamClean.sh`.

4) Le log des suppressions est écrit dans `~/.config/ShazamClean/rm_cleaning_list.log`.

Remarques de sécurité:
- Les chemins en dehors de $HOME sont ignorés.
- Si `gio` ou `trash-put` existe, la corbeille est utilisée.
- Par défaut le script fait une passe d'affichage (dry-run) ; la suppression réelle demande confirmation.
