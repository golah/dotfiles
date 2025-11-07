#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles" # Where you'll clone the repo

# Alacritty
mkdir -p ~/.config/alacritty
ln -sf "$DOTFILES_DIR/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml
ln -sf "$DOTFILES_DIR/alacritty/themes" ~/.config/alacritty/themes # If it's a dir

# Tmux
ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

# Neovim - symlink entire dir to capture lua substructure
rm -rf ~/.config/nvim # Safe on new setups; backs up if needed on existing
ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim

# Zsh
ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc

echo "Symlinks created!"
