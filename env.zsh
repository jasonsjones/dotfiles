
# Personal Exports
export JAVA_HOME=$(/usr/libexec/java_home)
export M2_HOME=$HOME/blt/tools/maven/apache-maven-3.5.4
export VOLTA_HOME="$HOME/.volta"
export PATH="/usr/local/opt/node@16/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$HOME/blt:$HOME/bin:$M2_HOME/bin:$JAVA_HOME/bin:$VOLTA_HOME/bin"

if [[ -f "$HOME/certificates/sfdx_bundle.pem" ]]
then
    export NODE_EXTRA_CA_CERTS=$HOME/certificates/sfdx_bundle.pem
elif [[ -f "$HOME/.tls/tempCA/sfdc-dev-root.crt" ]]
then
    export NODE_EXTRA_CA_CERTS=$HOME/.tls/tempCA/sfdc-dev-root.crt
fi

export LEDGER="$HOME/finances/master_ledger.ldg"
export EDITOR='nvim'
export GPG_TTY=$(tty)
export SPACESHIP_PACKAGE_SYMBOL="📦  "
export SPACESHIP_DOCKER_SYMBOL="🐳  "

# colors
export RESTORE='\033[0m'

export RED='\033[00;31m'
export GREEN='\033[00;32m'
export YELLOW='\033[00;33m'
export BLUE='\033[00;34m'
export PURPLE='\033[00;35m'
export CYAN='\033[00;36m'
export LIGHTGRAY='\033[00;37m'

