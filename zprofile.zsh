if [[ $(uname -m) = "arm64" && -e /opt/homebrew/bin/brew ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
fi
