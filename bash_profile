if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# update PATH to include personal bin if it exists
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
