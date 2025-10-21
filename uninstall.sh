grep -v "$SCRIPT_ALIAS" $BASHRC > temp.txt && mv temp.txt $BASHRC
#!/bin/bash

INSTALL_DIR="$HOME/.config/ShazamClean"
COMMAND_NAME="42clean"
ZSHRC="$HOME/.zshrc"
BASHRC="$HOME/.bashrc"

# Remove alias lines like: alias 42clean=...
remove_alias_from() {
	local rcfile="$1"
	if [ -f "$rcfile" ]; then
		# create a backup and delete lines starting with 'alias 42clean='
		sed -n '1,1p' "$rcfile" >/dev/null 2>&1
		sed -i.bak "/^alias ${COMMAND_NAME}=/d" "$rcfile" && echo "Removed alias from $rcfile (backup at ${rcfile}.bak)"
	fi
}

remove_alias_from "$ZSHRC"
remove_alias_from "$BASHRC"

# Remove install directory if present
if [ -d "$INSTALL_DIR" ]; then
	rm -rf -- "$INSTALL_DIR" && echo "$INSTALL_DIR removed"
else
	echo "$INSTALL_DIR not found, nothing to remove"
fi

echo "Successfully uninstalled ShazamClean ($COMMAND_NAME)"
