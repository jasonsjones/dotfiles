# Initialize Homebrew environment for login shells on Apple Silicon.
# This sets HOMEBREW_PREFIX, HOMEBREW_CELLAR, PATH, MANPATH, INFOPATH.
# path.zsh (sourced by .zshrc) references HOMEBREW_PREFIX and handles
# deduplication, so no further PATH work is needed here.
if [[ $(uname -m) = "arm64" && -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
