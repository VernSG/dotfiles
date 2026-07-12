#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# macos.sh — Sensible macOS defaults
# ─────────────────────────────────────────────────────────────────────────────
# Adapted from https://mths.be/macos
# Run once after a fresh install, then log out / restart for changes to apply.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DOTFILES_DIR/scripts/utils.sh"

step "Applying macOS system preferences"
info "Some changes require a logout or restart to take effect."

# Close System Preferences to prevent conflicts
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# ── General ───────────────────────────────────────────────────────────────────

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

success "General preferences set"

# ── Keyboard ──────────────────────────────────────────────────────────────────

# Set a fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Set a shorter delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

success "Keyboard preferences set"

# ── Finder ────────────────────────────────────────────────────────────────────

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view by default in Finder
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

success "Finder preferences set"

# ── Dock ──────────────────────────────────────────────────────────────────────

# Set Dock icon size
defaults write com.apple.dock tilesize -int 48

# Enable auto-hide
defaults write com.apple.dock autohide -bool true

# Remove the auto-hide delay
defaults write com.apple.dock autohide-delay -float 0

# Reduce the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.3

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

success "Dock preferences set"

# ── Screenshots ───────────────────────────────────────────────────────────────

# Save screenshots to ~/Pictures/Screenshots
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

# Save screenshots in PNG format
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

success "Screenshot preferences set"

# ── Activity Monitor ─────────────────────────────────────────────────────────

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

success "Activity Monitor preferences set"

# ── Apply Changes ─────────────────────────────────────────────────────────────

divider
info "Restarting affected applications..."

for app in "Finder" "Dock" "SystemUIServer"; do
    killall "$app" &>/dev/null || true
done

printf "\n"
success "macOS preferences applied!"
info "Some changes may require a logout or restart."
printf "\n"
