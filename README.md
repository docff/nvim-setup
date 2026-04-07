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

## Linux Install

### Debian/Ubuntu

```bash
sudo apt update
sudo apt install -y neovim git curl unzip ripgrep fd-find cmake build-essential tree-sitter-cli python3 cargo
```

If `fd` is not found after install, create an alias/symlink (`fdfind` is the binary name on some distros):

```bash
command -v fd || sudo ln -s "$(command -v fdfind)" /usr/local/bin/fd
```

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

- `ENOENT ... 'tree-sitter'` during `:TSUpdate`: `tree-sitter` CLI is missing from `PATH`. Install `tree-sitter-cli` and restart Neovim.
- `nvim-treesitter/install/...` build failures: ensure `cmake` and command line build tools are installed.
- `fd` not found on Debian/Ubuntu: install `fd-find` and map `fdfind` to `fd`.

