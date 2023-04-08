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
    ln -sf $PWD/alacritty.yml $HOME/.config/alacritty/

    if [[ ! -d $HOME/.config/zellij ]]; then
        mkdir -p $HOME/.config/zellij
    fi
    ln -sf $PWD/config/zellij/config.kdl $HOME/.config/zellij
    ln -sf $PWD/config/zellij/layouts $HOME/.config/zellij

    echo "\nNeed to source ~/.zshrc. Run:"
    echo "\n   \$ source ~/.zshrc"

    cd -
}

if [[ ! -d $NVIM_HOME ]]; then
    echo "Neovim config files not installed.  To install neovim config, run:"
    echo "\n   \$  git clone git@github.com:jasonsjones/neovim-config.git $NVIM_HOME"
fi


echo "Run 'link_dotfiles' to symlink all dotfiles to the correct spot...\n"

