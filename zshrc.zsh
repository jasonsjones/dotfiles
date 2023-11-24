# Path to your oh-my-zsh installation.
export ZSH=/Users/jasonjones/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
# if [[ $TERM_PROGRAM != "WarpTerminal" && -d $ZSH/custom/themes/spaceship-prompt ]]; then
#     ZSH_THEME="spaceship"
# fi

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
plugins=(git gitfast node yarn docker docker-compose vi-mode z zsh-autosuggestions zsh-syntax-highlighting)

# User configuration

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

if [[ -f "$HOME/.bootstrap_rc" ]]; then
    source /Users/jasonjones/.bootstrap_rc
fi

# Put all configuration to construct $PATH here since this is the last config to be loaded when
# an interactive shell is created.
# Ref: https://0xmachos.com/2021-05-13-zsh-path-macos/
#
# Personal Exports
export JAVA_HOME=$(/usr/libexec/java_home)
export M2_HOME=$HOME/blt/tools/maven/apache-maven-3.5.4
export VOLTA_HOME="$HOME/.volta"
export CC="/usr/bin/clang -std=c++17"
COMMON_PATH=/opt/X11/bin:$HOME/blt:$HOME/bin:$M2_HOME/bin:$JAVA_HOME/bin:$VOLTA_HOME/bin

# Update env vars whether or not we're runing on the mac studio (M1) or MBP
if [[ $(hostname -s) == *wsm* ]]; then
    # configure homebrew dir for M1 mac first to override system binaries
    export PATH=/opt/homebrew/bin:$COMMON_PATH:$PATH

    # configure CORE directory to point to core-on-git when running on mac studio
    export CORE=$HOME/projects/git-core/core-public
else
    # configure homebrew dir for intel mac first to override system binaries
    export PATH=/usr/local/bin:$COMMON_PATH:$PATH
fi

