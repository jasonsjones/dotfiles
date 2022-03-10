PLUGINS_DIR="$ZSH/custom/plugins"
THEMES_DIR="$ZSH/custom/themes"
CURRENT_DIR=$PWD

update () {
    cd $1
    echo "Updating source for plugin located at $PWD..."
    git pull --rebase origin master
    echo ""
    echo ""
}

update "$PLUGINS_DIR/zsh-autosuggestions"
update "$PLUGINS_DIR/zsh-syntax-highlighting"
update "$PLUGINS_DIR/zsh-vi-mode"
update "$THEMES_DIR/spaceship-prompt"

cd $CURRENT_DIR

