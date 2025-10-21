#!/bin/bash

COMMAND_NAME="42clean"
# Configure the GitHub source for the script. Change GITHUB_OWNER to your fork owner
# and BRANCH to the branch you want to use (e.g. 'main').
GITHUB_OWNER="RaphyStoll"
REPO="ShazamClean"
BRANCH="main"
# Direct raw link to your fork's script (uses the 'main' branch).
# If you want a different branch, update this URL or change BRANCH.
RAW_URL="https://raw.githubusercontent.com/RaphyStoll/ShazamClean/main/ShazamClean.sh"

# The alias runs bash and downloads the script on demand from RAW_URL.
SCRIPT_ALIAS="alias $COMMAND_NAME='/bin/bash -c \"\$(curl -fsSL $RAW_URL)\"'"

add_alias() {
	FILE_RC=$1
	if ! grep "$SCRIPT_ALIAS" $FILE_RC &> /dev/null; then
		echo "" >> $FILE_RC
		echo $SCRIPT_ALIAS >> $FILE_RC
		echo "Added $COMMAND_NAME alias to $FILE_RC"
	else
		echo "Alias already exists in $FILE_RC"
	fi
}

add_alias "$HOME/.zshrc"
add_alias "$HOME/.bashrc"
echo "Command available on shell restart: $COMMAND_NAME"
