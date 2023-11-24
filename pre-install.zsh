if [[ -d "$HOME/.oh-my-zsh" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH/custom/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH/custom/plugins/zsh-syntax-highlighting"
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH/custom/themes/spaceship-prompt" --depth=1
    ln -s "$ZSH/custom/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/custom/themes/spaceship.zsh-theme"
else
    echo "Looks like OhmyZsh it not yet installed.  Please install and re-run this script"
fi


git clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
ln -sf $HOME/.tmux/.tmux.conf $HOME/

