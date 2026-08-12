ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM_DIR=$ZSH/custom
BASEDIR=${${(%):-%N}:A:h}

typeset -A DOTFILE_LINKS=(
    ["$HOME/.zshrc"]="zshrc.zsh"
    ["$HOME/.zprofile"]="zprofile.zsh"
    ["$ZSH_CUSTOM_DIR/aliases.zsh"]="aliases.zsh"
    ["$ZSH_CUSTOM_DIR/env.zsh"]="env.zsh"
    ["$HOME/.tmux.conf.local"]="config/tmux/tmux.conf.local"
    ["$HOME/.gitconfig"]="gitconfig"
    ["$HOME/.ideavimrc"]="ideavimrc"
    ["$HOME/.config/alacritty"]="config/alacritty"
    ["$HOME/.config/zellij"]="config/zellij"
)

# TODO: add function to install neovim (see ~/tmp/util-functions.zsh)

install_brew_binaries() {
    for binary in $(cat brew_binaries.txt); do
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
    echo "\nLinking each dotfile to its respective location"

    local target source
    for target source in ${(kv)DOTFILE_LINKS}; do
        mkdir -p "${target:h}"
        ln -sfn "$BASEDIR/$source" "$target"
    done

    # path.d/ is referenced by path.zsh at its canonical location inside the
    # dotfiles repo — no symlink needed, but ensure the directory exists.
    mkdir -p "$BASEDIR/path.d"

    # Make zshrc.zsh immutable so third-party installers can't append
    # `export PATH=...` / `export NODE_EXTRA_CA_CERTS=...` to it. See CLAUDE.md
    # ("zshrc.zsh is immutable") for how to edit it and how to recover if a
    # write slips through (zshrc-check / zshrc-heal).
    chflags uchg "$BASEDIR/zshrc.zsh"

    echo "\nNeed to source ~/.zshrc. Run:"
    echo "\n   \$ source ~/.zshrc"

}

link_nvim_config () {
    mkdir -p $HOME/.config/nvim
    ln -sfn "$BASEDIR/config/nvim" "$HOME/.config/nvim"
}

link_warp_config () {
    mkdir -p $HOME/.warp

    echo "Linking warp config..."
    ln -sfn "$BASEDIR/warp"/* "$HOME/.warp/"
}

link_wezterm_config () {
    mkdir -p $HOME/.config/wezterm
    ln -sfn "$BASEDIR/config/wezterm" "$HOME/.config/wezterm"
}

echo "Run 'install_ohmyzsh' to install oh-my-zsh and the two plugins\n"
echo "Run 'install_brew_binaries' to install the 'brew' binaries defined in ./brew_binaries.txt"
echo "    contents of 'brew_binaries.txt:"
echo ""
\cat brew_binaries.txt
echo ""
echo "Run 'link_dotfiles' to symlink all dotfiles to the correct spot..."
echo "Run 'link_nvim_config' to symlink the nvim config...\n"
echo "Run 'link_warp_config' to symlink the warp config..."
echo "Run 'link_wezterm_config' to symlink the wezterm config...\n"
