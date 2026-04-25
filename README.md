# Neovim Configuration

This repository contains a Neovim setup powered by `lazy.nvim`, Tree-sitter,
Telescope, Mason LSP tooling, and related plugins.

## Requirements

Install these tools before first launch.

### Core

- `nvim` (recommended: latest stable)
- `git`
- `curl`
- `unzip`

### Plugin build/runtime tools

- `tree-sitter` CLI (required by `nvim-treesitter`)
- `cmake` (required by `telescope-fzf-native.nvim`)
- C/C++ compiler toolchain (`clang` on macOS via Xcode Command Line Tools)

### Nerd Font (required for icons)

`nvim-web-devicons` (used by oil.nvim, nvim-tree, lualine, etc.) requires a Nerd Font set in
your terminal emulator. Without it, file/folder icons will appear as boxes or question marks.

Recommended: **JetBrainsMono Nerd Font**

### Useful Telescope dependencies

- `ripgrep` (`rg`) for fast grep/search
- `fd` for fast file discovery

### LSP tools

LSP servers are installed by Mason, but runtime dependencies may still be needed:

- `python3` (for `basedpyright`)
- Rust toolchain (`rustup`/`cargo`) for Rust projects

## macOS Install (Homebrew)

```bash
brew install neovim git curl unzip ripgrep fd cmake tree-sitter-cli
xcode-select --install
```

Install a Nerd Font and set it in your terminal (iTerm2 / Terminal.app preferences):

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

## Linux Install

### Debian/Ubuntu

```bash
sudo apt update
sudo apt install -y neovim git curl unzip ripgrep fd-find cmake build-essential python3 python3-venv nodejs npm
```

If `fd` is not found after install, create an alias/symlink (`fdfind` is the binary name on some distros):

```bash
command -v fd || sudo ln -s "$(command -v fdfind)" /usr/local/bin/fd
```

**Ubuntu-specific: Nerd Font**

Install JetBrainsMono Nerd Font (for icons in oil.nvim, nvim-tree, lualine, etc.):

```bash
mkdir -p ~/.local/share/fonts
curl -fLo /tmp/JetBrainsMono.zip \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMonoNF/ '*.ttf'
fc-cache -fv ~/.local/share/fonts/
```

Then set **JetBrainsMono Nerd Font** as the font in your terminal emulator (Konsole: Settings →
Edit Current Profile → Appearance → Font).

**Ubuntu-specific: `tree-sitter-cli`**

The `tree-sitter-cli` package in apt is too old (v0.20.x). `nvim-treesitter` requires v0.26.1+.
Install the pre-built binary instead:

```bash
curl -L https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.4/tree-sitter-linux-x64.gz \
  -o /tmp/tree-sitter.gz \
  && gunzip /tmp/tree-sitter.gz \
  && chmod +x /tmp/tree-sitter \
  && mkdir -p ~/.local/bin \
  && mv /tmp/tree-sitter ~/.local/bin/tree-sitter
```

Verify `~/.local/bin` is in your `PATH` (it typically is on Ubuntu), then confirm:

```bash
tree-sitter --version   # should print 0.26.x
```

**Ubuntu-specific: `telescope-fzf-native.nvim`**

The cmake build step for `telescope-fzf-native.nvim` may not run automatically on first install.
If you see `libfzf.so: No such file or directory`, build it manually:

```bash
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install
```

Or from inside Neovim: `:Lazy build telescope-fzf-native.nvim`

### Arch Linux

```bash
sudo pacman -S --needed neovim git curl unzip ripgrep fd cmake base-devel tree-sitter-cli python cargo
```

## Agent Bootstrap (Any Machine)

Use this sequence on a fresh machine:

```bash
git clone <your-repo-url> ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
nvim --headless "+TSUpdate" +qa
```

Then open Neovim normally and run `:Mason` to install/confirm LSP servers.

## Setup

1. Clone this repo into your Neovim config directory:

```bash
git clone https://github.com/docff/nvim-setup.git ~/.config/nvim
```

2. Start Neovim:

```bash
nvim
```

3. Let `lazy.nvim` install plugins, then run:

```vim
:Lazy sync
:TSUpdate
:Mason
```

Install the listed LSP servers from Mason if they are not already installed.

4. Keep secrets out of this repository:

- Do not commit API keys/tokens in Lua files or dotfiles.
- Store credentials in environment variables (shell profile, secret manager, or CI secrets).
- Verify with `git diff` before committing.

## Verify Installation

Inside Neovim:

```vim
:checkhealth
:checkhealth nvim-treesitter
```

In shell:

```bash
command -v tree-sitter
tree-sitter --version
command -v rg
command -v fd
```

## Troubleshooting

- `ENOENT ... 'tree-sitter'` during `:TSUpdate`: `tree-sitter` CLI is missing from `PATH`. On Ubuntu, install the binary manually (see Ubuntu-specific section above) — the apt package is too old.
- `tree-sitter build` subcommand not recognized: apt version is too old (v0.20.x). Install v0.26.1+ binary from GitHub releases (see Ubuntu-specific section above).
- `libfzf.so: No such file or directory` for telescope-fzf-native: run the cmake build manually (see Ubuntu-specific section above).
- Mason fails to install `basedpyright`: install `python3-venv` (`sudo apt install python3-venv`) — Mason creates a venv to isolate the LSP and fails silently without it.
- `nvim-treesitter/install/...` build failures: ensure `cmake` and `build-essential` are installed.
- `fd` not found on Debian/Ubuntu: install `fd-find` and map `fdfind` to `fd`.

