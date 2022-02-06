NVIM_HOME=$HOME/.config/nvim
ZSH_CUSTOM_DIR=$ZSH/custom
BASEDIR=$(dirname $0)

if [[ ! -d $NVIM_HOME ]]; then
    echo "Neovim config files not installed.  To install neovim config, run:"
    echo "\n   \$  git clone git@github.com:jasonsjones/neovim-config.git $NVIM_HOME"
fi

echo "\nCopying each dotfile to its respective location"

cd $BASEDIR

ln -sf $PWD/zshrc.zsh $HOME/.zshrc
ln -sf $PWD/aliases.zsh $ZSH_CUSTOM_DIR/aliases.zsh
ln -sf $PWD/env.zsh $ZSH_CUSTOM_DIR/env.zsh
ln -sf $PWD/tmux.conf.local $HOME/.tmux.conf.local
ln -sf $PWD/gitconfig $HOME/.gitconfig
ln -sf $PWD/ideavimrc $HOME/.ideavimrc

if [[ ! -d $HOME/.config/alacritty ]]; then
    mkdir -p $HOME/.config/alacritty
fi
ln -sf $PWD/alacritty.yml $HOME/.config/alacritty/


echo "\nNeed to source ~/.zshrc. Run:"
echo "\n   \$ source ~/.zshrc"

cd -

