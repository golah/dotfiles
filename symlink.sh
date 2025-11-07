#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles" # Where you'll clone the repo

# Alacritty
mkdir -p ~/.config/alacritty
ln -sf "$DOTFILES_DIR/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml
ln -sf "$DOTFILES_DIR/alacritty/themes" ~/.config/alacritty/themes # If it's a dir

# Tmux
ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

# Neovim
mkdir -p ~/.config/nvim
ln -sf "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/init.lua
# Add more for other nvim files

echo "Symlinks created!"
