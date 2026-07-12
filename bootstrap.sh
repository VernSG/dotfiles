#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# bootstrap.sh — Set up a fresh Mac from scratch
# ─────────────────────────────────────────────────────────────────────────────
# This script is designed to be run on a brand-new Mac. It installs the
# minimum dependencies needed to clone and set up the dotfiles repository.
#
# Usage (one-liner from a fresh Mac):
#   curl -fsSL https://raw.githubusercontent.com/VernSG/dotfiles/main/bootstrap.sh | bash
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

# ── Colors (inline — utils.sh isn't available yet) ────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

info()    { printf "${BLUE}[INFO]${RESET} %s\n" "$1"; }
success() { printf "${GREEN}[  ✓ ]${RESET} %s\n" "$1"; }
warn()    { printf "${YELLOW}[WARN]${RESET} %s\n" "$1"; }
error()   { printf "${RED}[ERR ]${RESET} %s\n" "$1"; }
step()    { printf "\n${BOLD}${MAGENTA}▸ %s${RESET}\n" "$1"; }
divider() { printf "${DIM}────────────────────────────────────────────────────────────${RESET}\n"; }

DOTFILES_REPO="https://github.com/VernSG/dotfiles.git"
DOTFILES_DIR="$HOME/Documents/dotfiles"

# ─────────────────────────────────────────────────────────────────────────────
# 1. Xcode Command Line Tools
# ─────────────────────────────────────────────────────────────────────────────
step "Checking for Xcode Command Line Tools"

if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install

    # Wait for installation to complete
    until xcode-select -p &>/dev/null; do
        sleep 5
    done

    success "Xcode Command Line Tools installed"
else
    success "Xcode Command Line Tools already installed"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 2. Homebrew
# ─────────────────────────────────────────────────────────────────────────────
step "Checking for Homebrew"

if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    success "Homebrew installed"
else
    success "Homebrew already installed"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 3. Git
# ─────────────────────────────────────────────────────────────────────────────
step "Checking for Git"

if ! command -v git &>/dev/null; then
    info "Installing Git via Homebrew..."
    brew install git
    success "Git installed"
else
    success "Git already installed ($(git --version))"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 4. Clone dotfiles repository
# ─────────────────────────────────────────────────────────────────────────────
step "Cloning dotfiles repository"

if [[ -d "$DOTFILES_DIR" ]]; then
    warn "Dotfiles directory already exists at $DOTFILES_DIR"
    info "Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull --rebase
    success "Dotfiles updated"
else
    info "Cloning into $DOTFILES_DIR..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    success "Dotfiles cloned"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 5. Run installer
# ─────────────────────────────────────────────────────────────────────────────
step "Running installer"

cd "$DOTFILES_DIR"
bash install.sh

# ─────────────────────────────────────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────────────────────────────────────
divider
printf "\n"
success "Bootstrap complete! 🎉"
info "Open a new terminal window to start with your new configuration."
info "Optionally run: ./macos.sh to apply macOS system preferences."
printf "\n"
