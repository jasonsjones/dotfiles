#!/bin/sh

echo $PWD

if [[ $OSTYPE == darwin* ]]; then
    if [ ! -d $HOME/.vim ]; then
        echo "Cloning vim config files from github..."
        git clone git@github.com:jasonsjones/vim-config.git ~/.vim
    else
        echo "$HOME/.vim directory already exists, not cloning any configs from github"
    fi
    echo "Copying each dotfile to its respective location for MacOS"
    # add other macos specific symlinks here, e.g:
    # uncomment to install

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
elif [[ $OSTYPE == linux* ]]; then
    echo "Copying each dotfile to its respective location for Linux"
else
    echo "This operating system is not supported"
    exit 1
fi
