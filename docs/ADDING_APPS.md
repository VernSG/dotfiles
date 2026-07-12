# Adding a New Application

This guide explains how to add a new application's configuration to the dotfiles repository.

## Step-by-Step

### 1. Create a Stow package directory

Each application gets its own top-level directory. The directory structure inside it
must mirror where the files live relative to `$HOME`.

**Example: An app whose config lives at `~/.config/nvim/init.lua`**

```
dotfiles/
└── nvim/                        ← Stow package name
    └── .config/
        └── nvim/
            └── init.lua         ← Config file
```

**Example: An app whose config lives at `~/.tmux.conf`**

```
dotfiles/
└── tmux/                        ← Stow package name
    └── .tmux.conf               ← Config file
```

### 2. Add your config files

Copy or move your existing config files into the new package directory:

```bash
# For XDG-style configs (~/.config/app/)
mkdir -p appname/.config/appname
cp ~/.config/appname/config.toml appname/.config/appname/

# For home-directory dotfiles (~/.apprc)
mkdir -p appname
cp ~/.apprc appname/
```

### 3. Register the package in install.sh

Open `install.sh` and add your package name to the `STOW_PACKAGES` array:

```bash
STOW_PACKAGES=(
    zsh
    git
    kitty
    fastfetch
    appname        # ← Add here
)
```

### 4. Create the symlink

```bash
# From the dotfiles directory:
stow appname
```

Or re-run the full installer:

```bash
./install.sh
```

### 5. Commit your changes

```bash
git add appname/
git commit -m "feat: add appname configuration"
```

## Tips

- **Test first**: Use `stow --simulate appname` to preview what symlinks will be created.
- **Conflict resolution**: If files already exist, use `stow --adopt appname` to move them into the repo, then `git checkout -- appname/` to restore your repo versions.
- **Ignore files**: Add patterns to the package's `.stow-local-ignore` file to exclude specific files from symlinking.
