#!/bin/sh

VIM_HOME=$HOME/.vim
NVIM_HOME=$HOME/.config/nvim
ZSH_CUSTOM_DIR=$ZSH/custom

if [ ! -d $VIM_HOME ]; then
    echo "Vim config files not installed.  To install vim config, run:"
    echo "\n   \$  git clone git@github.com:jasonsjones/vim-config.git $VIM_HOME"
fi

if [ ! -d $NVIM_HOME ]; then
    echo "Neovim config files not installed.  To install neovim config, run:"
    echo "\n   \$  git clone git@github.com:jasonsjones/neovim-config.git $NVIM_HOME"
fi

echo "\nCopying each dotfile to its respective location"

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

