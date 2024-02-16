ZSH_CUSTOM_DIR=$ZSH/custom
BASEDIR=$(dirname $0)

# TODO: add function to install neovim (see ~/tmp/util-functions.zsh)

link_dotfiles () {
    echo "\nCopying each dotfile to its respective location"

    cd $BASEDIR
    mkdir -p $HOME/.config/alacritty
    mkdir -p $HOME/.config/zellij

    ln -sf $PWD/zshrc.zsh $HOME/.zshrc
    ln -sf $PWD/zprofile.zsh $HOME/.zprofile
    ln -sf $PWD/aliases.zsh $ZSH_CUSTOM_DIR/aliases.zsh
    ln -sf $PWD/env.zsh $ZSH_CUSTOM_DIR/env.zsh
    ln -sf $PWD/tmux.conf.local $HOME/.tmux.conf.local
    ln -sf $PWD/gitconfig $HOME/.gitconfig
    ln -sf $PWD/ideavimrc $HOME/.ideavimrc

    ln -sf $PWD/config/alacritty $HOME/.config/alacritty
    ln -sf $PWD/config/zellij $HOME/.config/zellij

    echo "\nNeed to source ~/.zshrc. Run:"
    echo "\n   \$ source ~/.zshrc"

    cd -
}

link_nvim_config () {
    cd $BASEDIR
    mkdir -p $HOME/.config/nvim
    ln -sf $PWD/config/nvim $HOME/.config/nvim
    cd -
}

link_warp_config () {
    cd $BASEDIR
    mkdir -p $HOME/.warp

    echo "Linking warp config..."
    ln -sf $PWD/warp/* $HOME/.warp/

    cd -
}

link_wezterm_config () {
    cd $BASEDIR
    mkdir -p $HOME/.config/wezterm
    ln -sf $PWD/config/wezterm $HOME/.config/wezterm
    cd -
}

echo "Run 'link_dotfiles' to symlink all dotfiles to the correct spot..."
echo "Run 'link_nvim_config' to symlink the nvim config...\n"
echo "Run 'link_warp_config' to symlink the warp config..."
echo "Run 'link_wezterm_config' to symlink the wezterm config...\n"

