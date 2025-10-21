#!/bin/bash

COMMAND_NAME="42clean"
GITHUB_OWNER="RaphyStoll"
REPO="ShazamClean"
BRANCH="main"
RAW_URL="https://raw.githubusercontent.com/RaphyStoll/ShazamClean/main/ShazamClean.sh"

# Raw base url for config files
RAW_BASE="https://raw.githubusercontent.com/${GITHUB_OWNER}/${REPO}/${BRANCH}"
DEFAULT_CLEANING_LIST_URL="$RAW_BASE/cleaning_list.txt"
DEFAULT_RM_LIST_URL="$RAW_BASE/rm_cleaning_list.txt"

SCRIPT_FUNC_LINE="${COMMAND_NAME}() { curl -fsSL \"$RAW_URL\" | bash -s -- \"\$@\"; }"

add_alias() {
	FILE_RC=$1
	if [ -f "$FILE_RC" ]; then
		sed -i.bak -e "/^alias ${COMMAND_NAME}=/d" -e "/^${COMMAND_NAME}()/,/^}/d" "$FILE_RC" || true
		echo "" >> "$FILE_RC"
		echo "$SCRIPT_FUNC_LINE" >> "$FILE_RC"
		echo "Installed $COMMAND_NAME in $FILE_RC (backup at ${FILE_RC}.bak)"
	else
		echo "$FILE_RC not found, skipping"
	fi
}
add_alias "$HOME/.zshrc"
add_alias "$HOME/.bashrc"
echo "Command available on shell restart: $COMMAND_NAME"

# Ensure config directory and default files
CFG_DIR="$HOME/.config/ShazamClean"
mkdir -p "$CFG_DIR"

if [ ! -f "$CFG_DIR/cleaning_list.txt" ]; then
	if curl -fsSL "$DEFAULT_CLEANING_LIST_URL" -o "$CFG_DIR/cleaning_list.txt"; then
		echo "Downloaded default cleaning_list.txt to $CFG_DIR"
	else
		echo ".cache" > "$CFG_DIR/cleaning_list.txt"
		echo "Created default cleaning_list.txt in $CFG_DIR"
	fi
fi

if [ ! -f "$CFG_DIR/rm_cleaning_list.txt" ]; then
	if curl -fsSL "$DEFAULT_RM_LIST_URL" -o "$CFG_DIR/rm_cleaning_list.txt"; then
		echo "Downloaded default rm_cleaning_list.txt to $CFG_DIR"
	else
		# create an informative empty file
		cat > "$CFG_DIR/rm_cleaning_list.txt" <<EOF
# rm_cleaning_list.txt
# Add one path per line (relative to \$HOME or absolute). Lines starting with # are comments.
# By default this file is empty for safety.
EOF
		echo "Created empty rm_cleaning_list.txt in $CFG_DIR"
	fi
fi
