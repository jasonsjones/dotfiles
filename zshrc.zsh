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
#
# NOTE: zsh-syntax-highlighting needs to be the last plugin loaded because of how it hooks into
# the zsh line editor (ZLE)
plugins=(git gitfast node yarn vi-mode z zsh-autosuggestions zsh-syntax-highlighting)

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
hostname=$(hostname)
export VOLTA_HOME="$HOME/.volta"
# export CC="/usr/bin/clang -std=c++17"
COMMON_PATH=$VOLTA_HOME/bin:/opt/X11/bin:$HOME/blt:$HOME/bin

# Update env vars whether or not we're runing on the mac studio (M1) or MBP
if [[ "$hostname" == *wsm* || "$hostname"  == *ltmv7x4* ]]; then
    export JAVA_HOME=/opt/workspace/core-public/tools/Darwin/jdk/openjdk_17.0.12.0.101_17.53.12_aarch64

    # configure homebrew dir for M1 mac first to override system binaries
    export PATH=$COMMON_PATH:/opt/homebrew/bin:$JAVA_HOME/bin:$PATH

    if [[ "$hostname" == *wsm* ]]; then
        # configure CORE directory to point to core-on-git when running on mac studio
        export CORE=$HOME/projects/git-core/core-public
    else
        export CORE=/opt/workspace/core-public
    fi
else
    # configure homebrew dir for intel mac first to override system binaries
    export JAVA_HOME=$(/usr/libexec/java_home)
    export PATH=/usr/local/bin:$COMMON_PATH:$JAVA_HOME/bin:$PATH
fi

NOTES_DIR=$HOME/notes
JOURNAL_HOME=$NOTES_DIR/areas/journal
journal() {
    cd $NOTES_DIR
    year=$(date +%Y)
    journal_file_name=$(date +%y%m%d_journal)
    branch_name=$(date +%y%m%d-journal)
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    journal_file_path=$JOURNAL_HOME/$year/$journal_file_name.md

    # check if a git branch exist for this journal and switch to it
    # otherwise, create it.
    if git rev-parse --verify --quiet $branch_name > /dev/null; then
        if [[ $current_branch != $branch_name ]]; then
            git switch $branch_name
        fi
    else
        git switch -c $branch_name
    fi

    if [[ ! -e "$journal_file_path" ]]; then
        cp $JOURNAL_HOME/_template.md $journal_file_path
        sed -i '' "s/{{Date}}/$(date +%m-%d-%Y)/g" $journal_file_path
    fi
    nvim $journal_file_path
    cd - > /dev/null
}

find_commit_from_cl() {
    git sfdc show-p4-sync-commit -c $1
}

show_commit_from_cl() {
    git show $(git sfdc show-p4-sync-commit -c $1)
}

