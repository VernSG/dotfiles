#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# install.sh — Install packages, configure symlinks, and set up the environment
# ─────────────────────────────────────────────────────────────────────────────
# Usage: ./install.sh
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/scripts/utils.sh"

# ── Stow Packages ────────────────────────────────────────────────────────────
# Each directory listed here is a GNU Stow package that will be symlinked
# into $HOME. Add new packages to this array as you expand your dotfiles.
STOW_PACKAGES=(
    zsh
    git
    kitty
    fastfetch
)

# ─────────────────────────────────────────────────────────────────────────────
# 1. Verify Homebrew
# ─────────────────────────────────────────────────────────────────────────────
step "Checking for Homebrew"

if ! command_exists brew; then
    error "Homebrew is not installed."
    error "Run bootstrap.sh first, or install manually:"
    error "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

success "Homebrew found at $(which brew)"

# ─────────────────────────────────────────────────────────────────────────────
# 2. Install GNU Stow
# ─────────────────────────────────────────────────────────────────────────────
step "Checking for GNU Stow"

if ! command_exists stow; then
    info "GNU Stow not found. Installing via Homebrew..."
    brew install stow
    success "GNU Stow installed"
else
    success "GNU Stow found at $(which stow)"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 3. Install packages from Brewfile
# ─────────────────────────────────────────────────────────────────────────────
step "Installing packages from Brewfile"

if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock
    success "Brewfile packages installed"
else
    warn "Brewfile not found — skipping package installation"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 4. Create symlinks using GNU Stow
# ─────────────────────────────────────────────────────────────────────────────
step "Creating symlinks with GNU Stow"

for package in "${STOW_PACKAGES[@]}"; do
    if [[ ! -d "$DOTFILES_DIR/$package" ]]; then
        warn "Package directory '$package' not found — skipping"
        continue
    fi

    # Run stow in simulate mode first to detect conflicts
    if ! stow_output=$(stow -d "$DOTFILES_DIR" -t "$HOME" --simulate "$package" 2>&1); then
        warn "Conflicts detected for '$package':"
        echo "$stow_output" | sed 's/^/       /'

        if confirm "  Overwrite existing files for '$package'?"; then
            stow -d "$DOTFILES_DIR" -t "$HOME" --adopt "$package"
            # After --adopt, stow moves existing files into the repo.
            # Restore our repo versions by checking out the originals.
            git -C "$DOTFILES_DIR" checkout -- "$package/" 2>/dev/null || true
            success "Linked '$package' (conflicts resolved)"
        else
            warn "Skipped '$package'"
        fi
    else
        stow -d "$DOTFILES_DIR" -t "$HOME" "$package"
        success "Linked '$package'"
    fi
done

# ─────────────────────────────────────────────────────────────────────────────
# 5. Done
# ─────────────────────────────────────────────────────────────────────────────
divider
printf "\n"
success "Dotfiles installation complete!"
info "You may also want to run:"
info "  ./macos.sh     — Apply macOS system preferences"
info "  source ~/.zshrc — Reload your shell configuration"
printf "\n"
