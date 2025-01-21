#!/bin/bash

INSTALL_DIR="$HOME/.config/ShazamClean"
INPUT_FILE="$INSTALL_DIR/cleaning_list.txt"

RED="\033[1;91m"
GREEN="\033[1;92m"
YELLOW="\033[1;93m"
RESET="\033[0m"
BOLD="\033[1m"
UNDERLINE="\033[4m"
ITALIC="\033[3;93m"

abort(){
	echo -e $RED"ABORTED"$RESET
	exit 1
}

log_size(){
	if [ "$#" -ne 2 ]; then
		echo "Error: log_size expected 2 arguments: got $#: aborting" >&2
		abort
	fi
	local dir_name=$1
	local dir_size=$2
	echo -e "$dir_size\t\t$dir_name"
}

delete_directory_contents(){
	if [ "$#" -ne 1 ]; then
		echo "Error: delete_directory_contents expected 1 argument: got $#: aborting" >&2
		abort
	fi
	local dir=$1
	rm -rf "$dir"/* "$dir"/.* 2>/dev/null
}

process_directory(){
	if [ "$#" -ne 1 ]; then
		echo "Error: process_directory expected 1 argument: got $#: aborting" >&2
		abort
	fi
	local dir="$HOME/$1"
	local size
	if [ ! -d "$dir" ]; then
		size="Noexist"
	else
		size=$(du -sh "$dir" | awk '{print $1}')
		delete_directory_contents "$dir"
	fi
	log_size "$dir" "$size"
}

process_directories_from_file(){
	if [ "$#" -ne 1 ]; then
		echo "Error: process_directories_from_file expected 1 argument: got $#: aborting" >&2
		abort
	fi
	local file=$1
	if [ ! -f "$file" ] || [ ! -r "$file" ]; then
		echo "Error: input file "$file" does not exist or cannot be read: aborting" >&2
		abort
	fi
	echo -e $UNDERLINE"CLEARED\t\tDIRECTORY"$RESET
	while IFS= read -r dir || [ -n "$dir" ]; do
		if [ -z "$dir" ]; then
			continue
		fi
		process_directory "$dir"
	done < "$file"
}

display_space(){
	df -h | grep home | awk '{print $4}'
}

#main script
SPACE_BEFORE=$(display_space)
process_directories_from_file "$INPUT_FILE"
echo -e $BOLD"Total home size:\t" $(df -h | grep home | awk '{print $2}') $RESET
echo -e $RED"Free space before:\t" $SPACE_BEFORE $RESET
echo -e $GREEN"Free space after:\t" $(display_space) $RESET
echo -e $ITALIC "by Shazam ⚡︎bgolding (42Lausanne)" $RESET
