#!/bin/bash
set -e

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macos"
elif [[ -f /etc/arch-release ]] || [[ -f /etc/os-release && $(grep -i arch /etc/os-release) ]]; then
  OS="arch"
fi

# Clone dotfiles if not present
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/golah/dotfiles.git "$HOME/dotfiles" # Or git@github.com:... for SSH
fi

cd "$HOME/dotfiles"

# Install packages based on OS
if [[ "$OS" == "macos" ]]; then
  echo "Installing packages for macOS..."

  # Install Homebrew if missing
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew bundle install --file=Brewfile

elif [[ "$OS" == "arch" ]]; then
  echo "Installing packages for Arch/Omarchy..."

  # Install yay if missing
  if ! command -v yay &>/dev/null; then
    echo "Installing yay AUR helper..."
    sudo pacman -S --needed git base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$HOME/dotfiles"
  fi

  # Install pacman packages
  echo "Installing official packages..."
  grep -v '^#' packages.arch | grep -v '^$' | head -n 12 | xargs sudo pacman -S --needed --noconfirm

  # Install AUR packages
  echo "Installing AUR packages..."
  yay -S --needed --noconfirm ttf-meslo-nerd ttf-hack-nerd zsh-autosuggestions zsh-syntax-highlighting powerlevel10k-git

else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi

# Run symlink script
./symlink.sh

# For Lazy.nvim (adjust if not exact; sync installs/updates plugins)
nvim --headless "+Lazy! sync" +qa || true

# Reload tmux if running
tmux source-file ~/.tmux.conf || true

echo "Setup complete! Restart your terminal."
