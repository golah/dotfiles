#!/bin/bash
set -e

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Clone dotfiles if not present
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/golah/dotfiles.git "$HOME/dotfiles" # Or git@github.com:... for SSH
fi

cd "$HOME/dotfiles"

# Install packages from Brewfile
brew bundle install --file=Brewfile

# Run symlink script
./symlink.sh

# For Lazy.nvim (adjust if not exact; sync installs/updates plugins)
nvim --headless "+Lazy! sync" +qa || true

# Reload tmux if running
tmux source-file ~/.tmux.conf || true

echo "Setup complete! Restart your terminal."
