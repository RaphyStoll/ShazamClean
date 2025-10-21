#!/bin/bash

INPUT_FILE="$HOME/.config/ShazamClean/cleaning_list.txt"
RM_FILE="$HOME/.config/ShazamClean/rm_cleaning_list.txt"
RM_LOG="$HOME/.config/ShazamClean/rm_cleaning_list.log"

GREEN="\033[0;92m"
YELLOW="\033[0;93m"
CYAN="\033[0;96m"
BOLD_RED="\033[1;91m"
BOLD_GREEN="\033[1;92m"
BOLD_YELLOW="\033[1;93m"
RESET="\033[0m"
BOLD="\033[1m"
UNDERLINE="\033[4m"
ITALIC_WHITE="\033[3;0m"
ITALIC_YELLOW="\033[3;93m"

abort(){
	echo -e $BOLD_RED"ABORTED"$RESET
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
		sleep 0.01
	done < "$file"
}

safe_remove() {
	local target="$1"
	if command -v gio >/dev/null 2>&1; then
		gio trash -- "$target"
	elif command -v trash-put >/dev/null 2>&1; then
		trash-put -- "$target"
	else
		rm -rf -- "$target"
	fi
}

process_rm_clean(){
	# usage: process_rm_clean <file> [dry-run(1|0)] [force(1|0)]
	if [ "$#" -lt 1 ]; then
		echo "Error: process_rm_clean expected at least 1 argument: aborting" >&2
		abort
	fi
	local file="$1"
	local dry_run=${2:-1}
	local force=${3:-0}

	if [ ! -f "$file" ] || [ ! -r "$file" ]; then
		echo "Error: RM file '$file' missing or not readable" >&2
		return 1
	fi

	echo -e $UNDERLINE"CLEARED\t\tDIRECTORY"$RESET
	# First pass: list targets (show size and path like cleaning)
	while IFS= read -r line || [ -n "$line" ]; do
		line="${line%%#*}"
		line="$(echo -e "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		[ -z "$line" ] && continue

		if [[ "$line" = /* ]]; then
			abs="$line"
		else
			abs="$HOME/$line"
		fi
		abs="$(readlink -f -- "$abs" 2>/dev/null)" || abs="$HOME/$line"

		case "$abs" in
			"$HOME"/*)
				if [ -e "$abs" ]; then
					size=$(du -sh "$abs" 2>/dev/null | awk '{print $1}')
				else
					size="Noexist"
				fi
				log_size "$abs" "$size"
				;;
			*) echo "Skipping outside-home path: $abs" >&2 ;;
		esac
	done < "$file"

	if [ "$dry_run" -eq 1 ]; then
		echo "Dry-run: no files removed. Use force flag to actually remove." 
		return 0
	fi

	if [ "$force" -ne 1 ]; then
		read -p "Confirmer suppression des fichiers listés ? (y/N) " ans
		case "$ans" in
			[Yy]*) ;;
			*) echo "Abandon."; return 0 ;;
		esac
	fi

	# Second pass: actually remove and log
	while IFS= read -r original || [ -n "$original" ]; do
		original="${original%%#*}"
		original="$(echo -e "$original" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		[ -z "$original" ] && continue

		if [[ "$original" = /* ]]; then
			abs="$original"
		else
			abs="$HOME/$original"
		fi
		abs="$(readlink -f -- "$abs" 2>/dev/null)" || abs="$HOME/$original"

		case "$abs" in
			"$HOME"/*) ;;
			*) echo "$(date --iso-8601=seconds) SKIP OUTSIDE $abs" >> "$RM_LOG"; continue ;;
		esac

		if [ -e "$abs" ]; then
			if safe_remove "$abs"; then
				echo "$(date --iso-8601=seconds) REMOVED $abs" >> "$RM_LOG"
			else
				echo "$(date --iso-8601=seconds) FAIL $abs" >> "$RM_LOG"
			fi
		else
			echo "$(date --iso-8601=seconds) NOEXIST $abs" >> "$RM_LOG"
		fi
	done < "$file"
}

display_space(){
	df -h | grep $USER | awk '{print $4}'
}

ensure_config() {
	if [ ! -f "$INPUT_FILE" ] ; then
		echo -e $CYAN"Coping default config list: $INPUT_FILE"$RESET
		mkdir -p $(dirname "$INPUT_FILE")
		curl -fsSL https://raw.githubusercontent.com/BWG31/ShazamClean/refs/heads/main/cleaning_list.txt > "$INPUT_FILE"
	fi
}

main() {
	ensure_config

	# parse simple args for non-interactive confirmation
	FORCE_RM=0
	while [ "$#" -gt 0 ]; do
		case "$1" in
		  -y|--yes) FORCE_RM=1 ; shift ;;
		  --) shift; break ;;
		  -*) echo "Unknown option: $1"; shift ;;
		  *) break ;;
		esac
	done

	echo -e $YELLOW"Cleaning..."$RESET
	sleep 0.5
	SPACE_BEFORE=$(display_space)
	echo "=============================="
	process_directories_from_file "$INPUT_FILE"
	echo "=============================="
	echo -e $GREEN"Clean complete!"$RESET

	# Show RM dry-run and ask to execute
	if [ -f "$RM_FILE" ]; then
		echo "=============================="
		echo -e $YELLOW"Files listed for removal (dry-run):"$RESET
		process_rm_clean "$RM_FILE" 1
		if [ "$FORCE_RM" -eq 1 ]; then
			process_rm_clean "$RM_FILE" 0 1
		else
			read -p "Voulez-vous exécuter la suppression réelle des fichiers listés dans $RM_FILE ? (y/N) " resp
			case "$resp" in
			  [Yy]*) process_rm_clean "$RM_FILE" 0 1 ;;
			  *) echo "Suppression RM annulée." ;;
			esac
		fi
	fi
	sleep 0.5
	echo "=============================="
	echo -e $BOLD"Total home size:\t" $(df -h | grep $USER | awk '{print $2}') $RESET
	echo -e $BOLD_RED"Free space before:\t" $SPACE_BEFORE $RESET
	echo -e $BOLD_GREEN"Free space after:\t" $(display_space) $RESET
	echo "=============================="
	echo -e $CYAN"Edit cleaning list here: $INPUT_FILE" $RESET
	echo -e $ITALIC_YELLOW "by Shazam ⚡︎bgolding (42Lausanne) & jvoisard (42Lausanne)" $RESET
	echo -e $ITALIC_YELLOW "modified by raphalme (42Lausanne)" $RESET
}

main
