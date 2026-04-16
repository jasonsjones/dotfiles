# NODE_EXTRA_CA_CERTS: point at a single bundle so individual apps can't hijack
# this var by installing only their own cert.  To add a new cert source, edit
# bin/cert-bundle.sh and re-run it; the path below never needs to change.
CA_BUNDLE="$HOME/certificates/ca_bundle.pem"
if [[ -f "$CA_BUNDLE" ]]; then
    export NODE_EXTRA_CA_CERTS="$CA_BUNDLE"
elif [[ -f "$HOME/.tls/tempCA/sfdc-dev-root.crt" ]]; then
    export NODE_EXTRA_CA_CERTS="$HOME/.tls/tempCA/sfdc-dev-root.crt"
fi

export LEDGER="$HOME/ledgers/master_ledger.ldg"
export EDITOR='nvim'
export GPG_TTY=$(tty)
export ICLOUD_DRIVE_LOCATION=~/Library/Mobile\ Documents/com\~apple\~CloudDocs
export SPACESHIP_PACKAGE_SYMBOL="📦 "
export SPACESHIP_DOCKER_SYMBOL="🐳 "
export SPACESHIP_MAVEN_SYMBOL="🪶 "
export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
export VI_MODE_SET_CURSOR=true
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8a8a"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

export DISABLE_BAZELPROJECT_FILE_MONITORING_PATH_ENABLER=true
export COMPONENT_MONITORING_PROPERTIES=$HOME/projects/git-soma/componentMonitoring.properties

# colors
export RESTORE='\033[0m'

export RED='\033[00;31m'
export GREEN='\033[00;32m'
export YELLOW='\033[00;33m'
export BLUE='\033[00;34m'
export PURPLE='\033[00;35m'
export CYAN='\033[00;36m'
export LIGHTGRAY='\033[00;37m'

