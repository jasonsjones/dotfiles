get_java_home() {
    local base_dir="/opt/workspace/core-public/tools/Darwin/jdk"

    if [ ! -d "$base_dir" ]; then
        echo "Error: Directory $base_dir not found."
        return 1
    fi

    local latest_jdk
    latest_jdk=$(ls -dt "$base_dir"/openjdk_*_aarch64 2>/dev/null | head -n 1)

    if [ -z "$latest_jdk" ]; then
        echo "No matching openjdk_*_aarch64 directories found."
        return 1
    fi

    basename "$latest_jdk"
}

# Opens today's journal entry in nvim, creating it from a template if needed.
# Manages a dedicated git branch per day in the notes repo.
journal() {
    local NOTES_DIR=$HOME/notes
    local JOURNAL_HOME=$NOTES_DIR/areas/journal

    cd $NOTES_DIR
    local year=$(date +%Y)
    local journal_file_name=$(date +%y%m%d_journal)
    local branch_name=$(date +%y%m%d-journal)
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    local journal_file_path=$JOURNAL_HOME/$year/$journal_file_name.md

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

# Generates a random time between 09:30:00 and 21:30:00 (macOS/BSD compatible).
# Dependency of git_random_date.
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

# Creates a full Git-compatible date string with a random time.
# Usage: git_random_date MM/DD/YY
git_random_date() {
  if [ -z "$1" ]; then
    echo "Usage: git_random_date MM/DD/YY"
    return 1
  fi

  local input_date="$1"
  local date_and_tz_part
  date_and_tz_part=$(date -j -f "%m/%d/%y" "$input_date" "+%a %b %d %Y %z" 2>/dev/null)

  if [ -z "$date_and_tz_part" ]; then
     echo "Error: Invalid date format. Please use MM/DD/YY (e.g., 08/07/25)"
     return 1
  fi

  local time_part
  time_part=$(random_time)

  local date_part="${date_and_tz_part% *}"
  local tz_part="${date_and_tz_part##* }"

  echo "$date_part $time_part $tz_part"
}

# Git commit wrapper that stamps the commit with a random time on the given date.
# Usage: git-commit-rand -m "My message" [MM/DD/YY]
git-commit-rand() {
  local commit_msg
  local date_arg

  if [ "$1" = "-m" ] && [ -n "$2" ]; then
    commit_msg="$2"
    date_arg="$3"
  else
    echo "Usage: git-commit-rand -m \"<message>\" [MM/DD/YY]"
    return 1
  fi

  local date_str
  if [ -n "$date_arg" ]; then
    date_str=$(git_random_date "$date_arg")
  else
    date_str=$(git_random_date)
  fi

  if [ -z "$date_str" ]; then
    echo "Date generation failed."
    return 1
  fi

  echo "Running: git commit -m \"$commit_msg\" --date=\"$date_str\""
  git commit -m "$commit_msg" --date="$date_str"
}

# Clones a fork from the EMU org and wires up the upstream remote.
# Usage: gitclone_emu <repo-name>
gitclone_emu() {
    if [ -z "$1" ]; then
        echo "Error: Please provide a repository name."
        echo "Usage: gitclone_emu adk-experts-lwc"
        return 1
    fi

    local REPO_NAME=$1
    local TARGET_DIR=~/projects/git-emu
    local START_DIR=$(pwd)
    local MY_EMU_USER="jasonjones_sfemu"
    local ORG_EMU_NAME="salesforce-experience-platform-emu"
    local SSH_ALIAS="sfdc_emu"
    local FULL_PATH="$TARGET_DIR/$REPO_NAME"

    if [ -d "$FULL_PATH" ]; then
        echo "Error: Directory '$FULL_PATH' already exists."
        echo "Aborting to prevent overwriting or duplicate configuration."
        cd "$FULL_PATH"
        return 1
    fi

    cd "$TARGET_DIR" || { echo "Directory $TARGET_DIR not found"; return 1; }

    echo "--- Cloning $REPO_NAME from $MY_EMU_USER ---"
    git clone git@$SSH_ALIAS:$MY_EMU_USER/$REPO_NAME.git

    cd "$REPO_NAME" || return 1

    echo "--- Adding upstream remote: $ORG_EMU_NAME ---"
    git remote add upstream git@$SSH_ALIAS:$ORG_EMU_NAME/$REPO_NAME.git

    echo "--- Setup Complete in $(pwd)! ---"
    git remote -v

    cd "$START_DIR"
}
