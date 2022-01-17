#!/bin/sh

VIM_HOME=$HOME/.vim
NVIM_HOME=$HOME/.config/nvim
ZSH_CUSTOM_DIR=$ZSH/custom

if [ ! -d $VIM_HOME ]; then
    echo "Cloning vim config files from github..."
    git clone git@github.com:jasonsjones/vim-config.git $VIM_HOME
else
    echo "$VIM_HOME directory already exists, not cloning any configs from github"
fi

if [ ! -d $NVIM_HOME ]; then
    echo "Cloning neovim config files from github..."
    git clone git@github.com:jasonsjones/neovim-config.git $NVIM_HOME
else
    echo "$NVIM_HOME directory already exists, not cloning any configs from github"
fi
echo "\nCopying each dotfile to its respective location"

# add other macos specific symlinks here, e.g:
# uncomment to install

ln -sf $PWD/zshrc $HOME/.zshrc
ln -sf $PWD/aliases.zsh $ZSH_CUSTOM_DIR/aliases.zsh
ln -sf $PWD/env.zsh $ZSH_CUSTOM_DIR/env.zsh

    #ln -s $PWD/vimrc ~/.vimrc
    #ln -s $PWD/zshrc ~/.zshrc
    #ln -s $PWD/zsh_aliases ~/.zsh_aliases
    #ln -s $PWD/profile ~/.profile
    #ln -s $PWD/bash_profile ~/.bash_profile
    #ln -s $PWD/bashrc ~/.bashrc
    #ln -s $PWD/gitconfig ~/.gitconfig
    #ln -s $PWD/hyper.js ~/.hyper.js
    #ln -s $PWD/tmux.conf ~/.tmux.conf
    #ln -s $PWD/synery-client.conf ~/.synergy.conf

echo "\nNeed to source ~/.zshrc. Run:"
echo "\n   \$ source ~/.zshrc"

