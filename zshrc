source /Users/jasonjones/.bootstrap_rc
# Path to your oh-my-zsh installation.
export ZSH=/Users/jasonjones/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="spaceship"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gitfast node yarn docker docker-compose zsh-autosuggestions zsh-syntax-highlighting)

# User configuration

export M2_HOME=$HOME/blt/tools/maven/apache-maven-3.5.4
export JAVA_HOME=$HOME/blt/tools/Darwin/jdk/openjdk1.8.0_212_x64

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$HOME/blt:$HOME/bin:$M2_HOME/bin:$JAVA_HOME/bin"
# export MANPATH="/usr/local/man:$MANPATH"


if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='code'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

source $HOME/.zsh_aliases
if [ -f $HOME/.zsh_aliases_private ]; then
    source $HOME/.zsh_aliases_private
fi

# Personal Exports

if [[ $HOST == *"wsm"* ]]; then
  export P4PORT=ssl:p4proxy.seattle.soma.salesforce.com:1999
else
  export P4PORT=ssl:p4proxy.soma.salesforce.com:1999
fi

export NODE_EXTRA_CA_CERTS=$HOME/certificates/sfdx_bundle.pem
export P4USER=jasonjones
export P4CLIENT=jasonjones-ltm1-blt
export LEDGER="$HOME/finances/master_ledger.ldg"
export GIT_EDITOR="code --wait --new-window"
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
