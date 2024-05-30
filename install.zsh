ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM_DIR=$ZSH/custom
BASEDIR=$(dirname $0)

# TODO: add function to install neovim (see ~/tmp/util-functions.zsh)

install_brew_binaries() {
    for binary in $(cat brew_binaries.txt); do;
        echo "intalling $binary"
         brew install "$binary"
    done
}

install_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # add useful zsh plugins
    if [[ -d $HOME/.oh-my-zsh ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/custom/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
    fi
}

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

echo "Run 'install_ohmyzsh' to install oh-my-zsh and the two plugins\n"
echo "Run 'install_brew_binaries' to install the 'brew' binaries defined in ./brew_binaries.txt"
echo "\t contents of 'brew_binaries.txt"
cat brew_binaries.txt
echo "Run 'link_dotfiles' to symlink all dotfiles to the correct spot..."
echo "Run 'link_nvim_config' to symlink the nvim config...\n"
echo "Run 'link_warp_config' to symlink the warp config..."
echo "Run 'link_wezterm_config' to symlink the wezterm config...\n"

