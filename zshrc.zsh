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

get_java_home() {
    # 1. Define the base directory
    local base_dir="/opt/workspace/core-public/tools/Darwin/jdk"

    # 2. Check if the directory exists to avoid errors
    if [ ! -d "$base_dir" ]; then
        echo "Error: Directory $base_dir not found."
        return 1
    fi

    # 3. Find the most recently modified directory matching the pattern
    # -d: List directory names, not their contents
    # -t: Sort by modification time (newest first)
    local latest_jdk
    latest_jdk=$(ls -dt "$base_dir"/openjdk_*_aarch64 2>/dev/null | head -n 1)

    # 4. Check if we actually found a match
    if [ -z "$latest_jdk" ]; then
        echo "No matching openjdk_*_aarch64 directories found."
        return 1
    fi

    # 5. Return only the folder name (basename)
    basename "$latest_jdk"
}

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
    export JAVA_HOME=/opt/workspace/core-public/tools/Darwin/jdk/$(get_java_home)

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

# Added by dx-cli for Claude Code (native binary installation)
export PATH="$HOME/.local/bin:$PATH"
# TODO: update the above re-export of $PATH with the existing logic above to determine if
# we're on an M-chip or not.

# Added by dx-cli for Claude Code CA certificates
# export NODE_EXTRA_CA_CERTS="/Users/jasonjones/.claude/certs/salesforce-ca-bundle.pem"
#
# Note: for now, this cert is concatenated with others in a separate script located in
# ~/scripts/sfdx-local-certs.zsh
#



# Function to generate a # random_time.sh
#
# Generates a random time between 09:30:00 and 21:30:00.
#
# How it works:
# 1. We calculate the start and end times in seconds since midnight.
#    Start: 09:30:00 = 9*3600 + 30*60 = 34200 seconds
#    End:   21:30:00 = 21*3600 + 30*60 = 77400 seconds
# 2. The total range is 77400 - 34200 = 43200 seconds (exactly 12 hours).
# 3. We use awk to:
#    a. Seed its random number generator (`srand()`).
#    b. Generate a random integer between 0 and 43200 (`int(rand() * 43201)`).
#    c. Add this to our start time (34200) to get a random timestamp.
#    d. Format this timestamp as HH:MM:SS using `strftime("%T", ...)`.random time between 09:30:00 and 21:30:00
# Function to generate a random time between 09:30:00 and 21:30:00 (macOS/BSD compatible)
# This is a dependency for the next function.
random_time() {
  awk 'BEGIN {
    srand()
    total_seconds = int(rand() * 43201) + 34200
    hours = int(total_seconds / 3600)
    minutes = int((total_seconds % 3600) / 60)
    seconds = total_seconds % 60
    printf "%02d:%02d:%02d\n", hours, minutes, seconds
  }'
}

# Creates a full Git-compatible date string
# Usage: git_random_date MM/DD/YY
git_random_date() {
  # Check if a date argument was provided
  if [ -z "$1" ]; then
    echo "Usage: git_random_date MM/DD/YY"
    return 1 # Exit with an error
  fi

  local input_date="$1"

  # 1. Parse the input date and format it, including the correct
  #    timezone offset *for that specific date*.
  #    -j : "do not try to set the date"
  #    -f : "specify the input format"
  #    +%a %b %d %Y %z : "output as: <Day> <Mon> <DayNum> <Year> <Offset>"
  local date_and_tz_part
  date_and_tz_part=$(date -j -f "%m/%d/%y" "$input_date" "+%a %b %d %Y %z" 2>/dev/null)

  # Error handling for bad date input
  if [ -z "$date_and_tz_part" ]; then
     echo "Error: Invalid date format. Please use MM/DD/YY (e.g., 08/07/25)"
     return 1
  fi

  # 2. Get the random time from our other function
  local time_part
  time_part=$(random_time)

  # 3. Separate the date and timezone parts from the formatted string.
  #    The string is "Thu Aug 07 2025 -0700"
  #    This gets everything *except* the last part: "Thu Aug 07 2025"
  local date_part="${date_and_tz_part% *}"
  #    This gets *only* the last part: "-0700"
  local tz_part="${date_and_tz_part##* }"

  # 4. Echo the final, assembled string
  echo "$date_part $time_part $tz_part"
}

# A custom "git commit" wrapper for random-time dates
#
# Usage:
#   git-commit-rand -m "My message"           (for today)
#   git-commit-rand -m "My message" 08/07/25  (for specific date)
#
git-commit-rand() {
  local commit_msg
  local date_arg

  # Simple argument parsing: find the -m "message"
  if [ "$1" = "-m" ] && [ -n "$2" ]; then
    commit_msg="$2"
    # Get the optional date (it's $3)
    date_arg="$3"
  else
    echo "Usage: git-commit-rand -m \"<message>\" [MM/DD/YY]"
    return 1
  fi

  local date_str
  # Check if a date was provided to our function
  if [ -n "$date_arg" ]; then
    date_str=$(git_random_date "$date_arg")
  else
    date_str=$(git_random_date) # No date arg, so git_random_date will use today's
  fi

  # Check if git_random_date gave an error
  if [ -z "$date_str" ]; then
    echo "Date generation failed."
    return 1
  fi

  # --- The Final Command ---
  echo "Running: git commit -m \"$commit_msg\" --date=\"$date_str\""
  git commit -m "$commit_msg" --date="$date_str"
}

#alias git='f() { if [ "$1" = "commit-rand" ]; then shift; git-commit-rand "$@"; else command git "$@"; fi }; f'

# Function to automate GitHub EMU repo setup
# Usage: gclone_emu <repo-name>
gitclone_emu() {
    # Check if a repo name was provided
    if [ -z "$1" ]; then
        echo "Error: Please provide a repository name."
        echo "Usage: gclone_emu adk-experts-lwc"
        return 1
    fi

    local REPO_NAME=$1
    local TARGET_DIR=~/projects/github-emu
    local START_DIR=$(pwd)

    # Define your specific EMU namespaces
    local MY_EMU_USER="jasonjones_sfemu"
    local ORG_EMU_NAME="salesforce-experience-platform-emu"
    local SSH_ALIAS="sfdc_emu"

    # Check if the directory already exists
    if [ -d "$FULL_PATH" ]; then
        echo "Error: Directory '$FULL_PATH' already exists."
        echo "Aborting to prevent overwriting or duplicate configuration."
        # Navigate there anyway if you want to be helpful
        cd "$FULL_PATH"
        return 1
    fi

    # Navigate to your projects folder
    cd "$TARGET_DIR" || { echo "Directory $TARGET_DIR not found"; return 1; }

    echo "--- Cloning $REPO_NAME from $MY_EMU_USER ---"

    # Clone your fork
    git clone git@$SSH_ALIAS:$MY_EMU_USER/$REPO_NAME.git

    # Enter the new directory
    cd "$REPO_NAME" || return 1

    echo "--- Adding upstream remote: $ORG_EMU_NAME ---"

    # Add the upstream remote pointing to the source org
    git remote add upstream git@$SSH_ALIAS:$ORG_EMU_NAME/$REPO_NAME.git

    echo "--- Setup Complete in $(pwd)! ---"
    git remote -v

    # OPTIONAL: Uncomment the line below if you want to automatically
    # return to your original directory instead of staying in the repo.
    cd "$START_DIR"
}
