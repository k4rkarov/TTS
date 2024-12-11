#!/bin/bash

# ----------------
# - by @k4rkarov -
# ----------------

SCRIPT_NAME="BashRC with Steroids"
BACKUP_FILE="$HOME/.bashrc.backup"
BASHRC_FILE="$HOME/.bashrc"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

show_help() {
    echo -e "${CYAN}Usage:${RESET} $0 [${GREEN}options${RESET}]"
    echo ""
    echo -e "${CYAN}Options:${RESET}"
    echo -e "  ${GREEN}--help, -h${RESET}         Show this help menu and exit."
    echo -e "  ${GREEN}--restore${RESET}         Restore the original ~/.bashrc from the backup created during permanent setup."
    echo -e "  ${GREEN}--verbose, -v${RESET}     Display a detailed explanation of what the script modifies."
    echo ""
    echo -e "${CYAN}Description:${RESET}"
    echo -e "  ${YELLOW}$SCRIPT_NAME${RESET} enhances your shell environment by adding persistent history,"
    echo -e "  advanced history controls, and terminal management settings. Changes are made"
    echo -e "  permanent by appending configurations to your ~/.bashrc file."
    exit 0
}

restore_bashrc() {
    if [[ -f $BACKUP_FILE ]]; then
        cp $BACKUP_FILE $BASHRC_FILE
        echo -e "${GREEN}Original ~/.bashrc has been restored from the backup.${RESET}"
        source $BASHRC_FILE
    else
        echo -e "${RED}No backup found. Unable to restore.${RESET}"
        exit 1
    fi
}

show_verbose() {
    echo -e "${YELLOW}This script applies the following hardening settings to your Bash shell:${RESET}"
    echo ""
    echo -e "${BLUE}1. Persistent History:${RESET}"
    echo "   Synchronizes history between terminal sessions with immediate updates."
    echo "   - Adds executed commands to the history file immediately."
    echo "   - Loads the latest history into the current session."
    echo ""
    echo -e "${BLUE}2. History Ignore List:${RESET}"
    echo "   Excludes commands like 'ls', 'cd', 'pwd', 'clear' and 'history' from the history file."
    echo ""
    echo -e "${BLUE}3. Increased History Capacity:${RESET}"
    echo "   Allows storing up to 100,000 commands in memory and 10 million commands on disk."
    echo ""
    echo -e "${BLUE}4. Timestamp Format:${RESET}"
    echo "   Adds date and time (YYYY-MM-DD HH:MM:SS) to each command in the history."
    echo ""
    echo -e "${BLUE}5. History Control Features:${RESET}"
    echo "   - Prevents duplicate consecutive commands."
    echo "   - Skips commands starting with a space."
    echo ""
    echo -e "${BLUE}6. Terminal Resize Handling:${RESET}"
    echo "   Automatically adjusts terminal dimensions after resizing."
    exit 0
}

if [[ "$1" != "--help" && "$1" != "-h" && "$1" != "--restore" && "$1" != "--verbose" && "$1" != "-v" && -n "$1" ]]; then
    echo -e "${RED}Error:${RESET} Invalid option '$1'."
    echo -e "Run ${GREEN}$0 --help${RESET} to see the available options."
    exit 1
fi

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
elif [[ "$1" == "--restore" ]]; then
    restore_bashrc
    exit 0
elif [[ "$1" == "--verbose" || "$1" == "-v" ]]; then
    show_verbose
    exit 0
fi

if [[ ! -f $BACKUP_FILE ]]; then
    cp $BASHRC_FILE $BACKUP_FILE
    echo -e "${GREEN}Backup of the original ~/.bashrc created at $BACKUP_FILE.${RESET}"
fi

CONFIG="
# --- $SCRIPT_NAME ---
PROMPT_COMMAND=\"history -a; history -n\"
HISTIGNORE=\"ls:ll:cd:pwd:bg:fg:clear:history\"
HISTSIZE=100000
HISTFILESIZE=10000000
HISTTIMEFORMAT=\"%F %T \"
HISTCONTROL=ignoreboth
shopt -s histappend histreedit histverify checkwinsize
# --- End of $SCRIPT_NAME ---
"

echo "$CONFIG" >> $BASHRC_FILE

echo -e "${BLUE}The following changes have been applied to your ~/.bashrc:${RESET}"
echo -e "  - Persistent history updates."
echo -e "  - History capacity expanded."
echo -e "  - Excluded irrelevant commands from the history."
echo -e "  - Added timestamps to the history."
echo -e "  - Synchronized history across sessions."
echo -e "  - Adjusted terminal resizing behavior."
echo ""
echo -e "${GREEN}Changes will take effect in your next terminal session. To apply them now, run:${RESET}"
echo -e "${YELLOW}source ~/.bashrc${RESET}"

