#!/bin/bash

INSTALL_DIR="$HOME/.config/ShazamClean"
COMMAND_SCRIPT="ShazamClean.sh"
COMMAND_NAME="42clean"
ZSHRC="$HOME/.zshrc"
BASHRC="$HOME/.bashrc"
SCRIPT_ALIAS="alias $COMMAND_NAME=\"$INSTALL_DIR/$COMMAND_SCRIPT\""

grep -v "$SCRIPT_ALIAS" $ZSHRC > temp.txt && mv temp.txt $ZSHRC
grep -v "$SCRIPT_ALIAS" $BASHRC > temp.txt && mv temp.txt $BASHRC

rm -rf $INSTALL_DIR

echo "Successfully uninstalled ShazamClean (42clean)"
