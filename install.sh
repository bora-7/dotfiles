#!/bin/bash

DOTFILES="$HOME/.config/dotfiles"  # adjust to wherever you clone the repo

# Create symlinks
ln -sf "$DOTFILES/ghostty"            "$HOME/.config/ghostty"
ln -sf "$DOTFILES/nvim"               "$HOME/.config/nvim"
ln -sf "$DOTFILES/tmux/tmux.conf"     "$HOME/.tmux.conf"
ln -sf "$DOTFILES/git/ignore"         "$HOME/.config/git/ignore"
ln -sf "$DOTFILES/git/.gitconfig"     "$HOME/.gitconfig"
ln -sf "$DOTFILES/zsh/.zshrc"         "$HOME/.zshrc"
ln -sf "$DOTFILES/zsh/.p10k.zsh"      "$HOME/.p10k.zsh"
ln -sf "$DOTFILES/gh/config.yml"      "$HOME/.config/gh/config.yml"
ln -sf "$DOTFILES/Brewfile"           "$HOME/Brewfile"

echo "Dotfiles linked!"
