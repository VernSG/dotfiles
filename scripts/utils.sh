#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# utils.sh — Shared helper functions for dotfiles scripts
# ─────────────────────────────────────────────────────────────────────────────

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# ── Logging ───────────────────────────────────────────────────────────────────

info() {
    printf "${BLUE}[INFO]${RESET} %s\n" "$1"
}

success() {
    printf "${GREEN}[  ✓ ]${RESET} %s\n" "$1"
}

warn() {
    printf "${YELLOW}[WARN]${RESET} %s\n" "$1"
}

error() {
    printf "${RED}[ERR ]${RESET} %s\n" "$1"
}

step() {
    printf "\n${BOLD}${MAGENTA}▸ %s${RESET}\n" "$1"
}

# ── Utilities ─────────────────────────────────────────────────────────────────

# Ask for confirmation before proceeding.
# Usage: confirm "Do you want to continue?" && do_something
confirm() {
    local prompt="${1:-Are you sure?}"
    printf "${YELLOW}%s [y/N] ${RESET}" "$prompt"
    read -r response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Check if a command exists on the system.
command_exists() {
    command -v "$1" &>/dev/null
}

# Print a horizontal divider.
divider() {
    printf "${DIM}────────────────────────────────────────────────────────────${RESET}\n"
}
