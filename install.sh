#!/bin/bash

# Define variables
INSTALL_DIR="$HOME/.config/ShazamClean"
COMMAND_SCRIPT="ShazamClean.sh"
COMMAND_NAME="42clean"
CLEANING_LIST="cleaning_list.txt"
ZSHRC="$HOME/.zshrc"
BASHRC="$HOME/.bashrc"
SCRIPT_ALIAS="alias $COMMAND_NAME=\"$INSTALL_DIR/$COMMAND_SCRIPT\""

mkdir -p "$INSTALL_DIR"

if [ -e "$COMMAND_SCRIPT" ] && [ -e "$CLEANING_LIST" ]; then
	echo "Creating executable command..."
	cp "$COMMAND_SCRIPT" "$INSTALL_DIR/"
	cp "$CLEANING_LIST" "$INSTALL_DIR/"
	chmod +x "$INSTALL_DIR/$COMMAND_SCRIPT"
else
	echo "One of the required files is missing. Aborting install."
	exit 1
fi

if ! grep "$SCRIPT_ALIAS" $ZSHRC &> /dev/null; then
	echo "Adding $COMMAND_NAME alias to $ZSHRC"
	echo "" >> $ZSHRC
	echo $SCRIPT_ALIAS >> $ZSHRC
else
	echo "Alias already exists in $ZSHRC"
fi

if ! grep "$SCRIPT_ALIAS" $BASHRC &> /dev/null; then
	echo "Adding $COMMAND_NAME alias to $BASHRC"
	echo "" >> $BASHRC
	echo $SCRIPT_ALIAS >> $BASHRC
else
	echo "Alias already exists in $BASHRC"
fi

echo "Installation complete. Command available: $COMMAND_NAME"
