<h1 align="center">
  <br>
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
  🍵 dotfiles
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
  <br>
</h1>

<p align="center">
  <a href="#-overview">Overview</a> •
  <a href="#-structure">Structure</a> •
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-restoring-on-a-new-mac">Restore</a> •
  <a href="#-usage">Usage</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=white" alt="macOS"/>
  <img src="https://img.shields.io/badge/Zsh-F15A24?style=flat-square&logo=zsh&logoColor=white" alt="Zsh"/>
  <img src="https://img.shields.io/badge/Kitty-000000?style=flat-square&logo=gnometerminal&logoColor=white" alt="Kitty"/>
  <img src="https://img.shields.io/badge/Catppuccin_Mocha-1E1E2E?style=flat-square&logo=catppuccin&logoColor=B4BEFE" alt="Catppuccin Mocha"/>
  <img src="https://img.shields.io/badge/GNU_Stow-A42E2B?style=flat-square&logo=gnu&logoColor=white" alt="GNU Stow"/>
</p>

---

## 📋 Overview

Personal macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Designed to be simple, modular, and easy to restore on a fresh Mac.

**Stack:**

| Category | Tool |
|----------|------|
| Terminal | [Kitty](https://sw.kovidgoyal.net/kitty/) |
| Theme | [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) |
| Font | JetBrainsMono Nerd Font Mono |
| Shell | Zsh + [Powerlevel10k](https://github.com/romkatv/powerlevel10k) |
| Plugins | zsh-autosuggestions, zsh-syntax-highlighting |
| Packages | [Homebrew](https://brew.sh) |

---

## 📁 Structure

```
dotfiles/
├── README.md                     # This file
├── Brewfile                      # Homebrew packages
├── install.sh                    # Main installer
├── bootstrap.sh                  # Fresh Mac bootstrapper
├── macos.sh                      # macOS system preferences
├── .gitignore
│
├── zsh/                          # 🐚 Zsh configuration
│   ├── .zshrc                    #    Shell config
│   └── .p10k.zsh                 #    Powerlevel10k theme
│
├── git/                          # 🔀 Git configuration
│   └── .gitconfig                #    Aliases, GPG signing, LFS
│
├── kitty/                        # 🐱 Kitty terminal
│   └── .config/
│       └── kitty/
│           └── kitty.conf        #    Catppuccin Mocha theme
│
├── fastfetch/                    # 🚀 Fastfetch system info
│   └── .config/
│       └── fastfetch/
│
├── scripts/                      # 🛠  Helper scripts
│   └── utils.sh                  #    Shared functions
│
└── docs/                         # 📖 Documentation
    └── ADDING_APPS.md            #    How to add new apps
```

Each top-level directory (e.g., `zsh/`, `git/`, `kitty/`) is a **GNU Stow package**. Its internal structure mirrors where files are placed relative to `$HOME`.

---

## ⚡ Quick Start

**On a fresh Mac** — run this single command:

```bash
curl -fsSL https://raw.githubusercontent.com/VernSG/dotfiles/main/bootstrap.sh | bash
```

This will install Homebrew, clone the repo, install all packages, and set up symlinks.

---

## 🔧 Installation

**On a Mac that already has Homebrew and Git:**

```bash
# 1. Clone the repository
git clone https://github.com/VernSG/dotfiles.git ~/Documents/dotfiles

# 2. Run the installer
cd ~/Documents/dotfiles
chmod +x install.sh
./install.sh

# 3. (Optional) Apply macOS preferences
chmod +x macos.sh
./macos.sh
```

The installer will:
- ✅ Verify Homebrew is installed
- ✅ Install GNU Stow if missing
- ✅ Install all packages from the Brewfile
- ✅ Create symlinks via GNU Stow (with conflict detection)

---

## 🖥 Restoring on a New Mac

1. **Run the bootstrap script** (installs Homebrew, Git, and everything else):

   ```bash
   curl -fsSL https://raw.githubusercontent.com/VernSG/dotfiles/main/bootstrap.sh | bash
   ```

2. **Apply macOS preferences** (optional):

   ```bash
   cd ~/Documents/dotfiles
   ./macos.sh
   ```

3. **Install NVM and Bun** (not managed by Homebrew):

   ```bash
   # NVM
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

   # Bun
   curl -fsSL https://bun.sh/install | bash
   ```

4. **Import your GPG keys** and set up SSH keys.

5. **Open a new terminal** — your shell, theme, and tools will be ready.

---

## 📦 Usage

### Updating Dotfiles

After editing a config file, the change is already tracked since the file in `$HOME` is a symlink back to the repo:

```bash
cd ~/Documents/dotfiles
git add -A
git commit -m "update: description of change"
git push
```

To pull the latest changes on another machine:

```bash
cd ~/Documents/dotfiles
git pull
```

### Adding a New Application

1. Create a directory for the app with the correct file structure:

   ```bash
   # For ~/.config/app/ style configs:
   mkdir -p appname/.config/appname
   cp ~/.config/appname/config.toml appname/.config/appname/

   # For ~/. style configs:
   mkdir -p appname
   cp ~/.apprc appname/
   ```

2. Add the package name to the `STOW_PACKAGES` array in `install.sh`.

3. Create the symlink:

   ```bash
   stow appname
   ```

4. Commit and push.

See [docs/ADDING_APPS.md](docs/ADDING_APPS.md) for a detailed guide.

### Removing a Package

```bash
# Remove the symlinks
stow -D packagename

# Delete the directory
rm -rf packagename/

# Remove from STOW_PACKAGES in install.sh
```

---

## 🧩 How GNU Stow Works

GNU Stow creates symlinks from a package directory into a target directory (`$HOME` by default). The package's internal structure determines where each file ends up.

```
# Running `stow zsh` from ~/Documents/dotfiles creates:
~/.zshrc    →  ~/Documents/dotfiles/zsh/.zshrc
~/.p10k.zsh →  ~/Documents/dotfiles/zsh/.p10k.zsh
```

**Useful commands:**

| Command | Description |
|---------|-------------|
| `stow <pkg>` | Create symlinks for a package |
| `stow -D <pkg>` | Remove symlinks for a package |
| `stow -R <pkg>` | Restow (remove then create) |
| `stow --simulate <pkg>` | Preview what would happen |
| `stow --adopt <pkg>` | Move existing files into the repo |

---

## 📸 Screenshots

<!-- Add your terminal screenshots here -->
<!-- ![Terminal](screenshots/terminal.png) -->

---

## 📄 License

These are my personal dotfiles. Feel free to use them as inspiration for your own.
