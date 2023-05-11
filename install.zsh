NVIM_HOME=$HOME/.config/nvim
ZSH_CUSTOM_DIR=$ZSH/custom
BASEDIR=$(dirname $0)

# TODO: add function to install neovim (see ~/tmp/util-functions.zsh)
#
link_dotfiles () {
    echo "\nCopying each dotfile to its respective location"

    cd $BASEDIR

    ln -sf $PWD/zshrc.zsh $HOME/.zshrc
    ln -sf $PWD/zprofile.zsh $HOME/.zprofile
    ln -sf $PWD/aliases.zsh $ZSH_CUSTOM_DIR/aliases.zsh
    ln -sf $PWD/env.zsh $ZSH_CUSTOM_DIR/env.zsh
    ln -sf $PWD/tmux.conf.local $HOME/.tmux.conf.local
    ln -sf $PWD/gitconfig $HOME/.gitconfig
    ln -sf $PWD/ideavimrc $HOME/.ideavimrc

    if [[ ! -d $HOME/.config/alacritty ]]; then
        mkdir -p $HOME/.config/alacritty
    fi
    ln -sf $PWD/config/alacritty/alacritty.yml $HOME/.config/alacritty/

    if [[ ! -d $HOME/.config/zellij ]]; then
        mkdir -p $HOME/.config/zellij
    fi

    ln -sf $PWD/config/zellij/config.kdl $HOME/.config/zellij
    ln -sf $PWD/config/zellij/layouts $HOME/.config/zellij

    if [[ ! -d $HOME/.config/nvim ]]; then
        mkdir -p $HOME/.config/nvim
    fi

    ln -sf $PWD/config/nvim $HOME/.config/nvim

    echo "\nNeed to source ~/.zshrc. Run:"
    echo "\n   \$ source ~/.zshrc"

    cd -
}

link_warp_config () {
    cd $BASEDIR

    if [[ ! -d $HOME/.warp ]]; then
        echo "$HOME/.warp does not exist; creating..."
        mkdir -p $HOME/.warp
    fi

    echo "Linking warp config..."
    ln -sf $PWD/warp/* $HOME/.warp/

    cd -
}

echo "Run 'link_dotfiles' to symlink all dotfiles to the correct spot..."
echo "Run 'link_warp_config' to symlink the warp config...\n"

