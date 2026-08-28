# ── zshrc tamper detection / healing ──────────────────────────────────────────
# Third-party installers append `export PATH=...` / `export NODE_EXTRA_CA_CERTS=...`
# to ~/.zshrc as if they own it. The real config lives in dotfiles/zshrc.zsh (the
# symlink target) and ends with a sentinel line. Anything below the sentinel was
# injected. zshrc-check surfaces it; zshrc-heal relocates it and truncates back.

_ZSHRC_SENTINEL='### END OF ZSHRC — DO NOT APPEND ###'
# Resolve the real file behind the ~/.zshrc symlink (that's what gets sourced,
# and what an installer targeting "$HOME/.zshrc" actually writes through).
_zshrc_file() { local f="$HOME/.zshrc"; [[ -L "$f" ]] && f="$(readlink "$f")"; print -r -- "$f"; }

# Show any lines appended below the sentinel (i.e. injected by some tool).
zshrc-check() {
    local f; f="$(_zshrc_file)"
    if ! grep -qF "$_ZSHRC_SENTINEL" "$f"; then
        print -P "%F{red}No sentinel found in $f — did the file get rewritten?%f"
        return 2
    fi
    local injected
    injected="$(awk -v s="$_ZSHRC_SENTINEL" 'found{print} $0==s{found=1}' "$f")"
    if [[ -z "${injected//[$'\n\t ']/}" ]]; then
        print -P "%F{green}✓ Clean — nothing appended below the sentinel.%f"
        return 0
    fi
    print -P "%F{yellow}Injected below sentinel in $f:%f"
    print -r -- "$injected"
    return 1
}

# Relocate injected lines to their proper homes and truncate the file back to
# the sentinel. PATH dirs → path.d/injected.path; env exports → env.zsh; anything
# unrecognized is left in place and reported so it can be handled by hand.
zshrc-heal() {
    local f; f="$(_zshrc_file)"
    local dotfiles="${DOTFILES:-$HOME/dotfiles}"
    if ! grep -qF "$_ZSHRC_SENTINEL" "$f"; then
        print -P "%F{red}No sentinel in $f — refusing to heal a file I don't recognize.%f"
        return 2
    fi

    local injected
    injected="$(awk -v s="$_ZSHRC_SENTINEL" 'found{print} $0==s{found=1}' "$f")"
    if [[ -z "${injected//[$'\n\t ']/}" ]]; then
        print -P "%F{green}✓ Already clean — nothing to heal.%f"
        return 0
    fi

    # If the real file is immutable, temporarily clear the flag so we can rewrite.
    local was_locked=false
    if ls -lO "$f" 2>/dev/null | grep -q uchg; then
        was_locked=true
        chflags nouchg "$f"
    fi

    local pathfile="$dotfiles/path.d/injected.path"
    local unhandled="" line
    while IFS= read -r line; do
        [[ -z "${line//[$'\n\t ']/}" ]] && continue      # skip blanks
        [[ "$line" == \#* ]] && continue                  # skip comments
        if [[ "$line" == *NODE_EXTRA_CA_CERTS* ]]; then
            print -P "%F{yellow}↷ NODE_EXTRA_CA_CERTS injection dropped (env.zsh already pins it):%f\n    $line"
        elif [[ "$line" == *"export PATH="* || "$line" == *"PATH=\""*"\$PATH"* ]]; then
            # Pull out dirs added ahead of $PATH and persist each to path.d/.
            local rhs="${line#*PATH=}"; rhs="${rhs%%\$PATH*}"
            rhs="${rhs//\"/}"; rhs="${rhs//\'/}"; rhs="${rhs%:}"
            local d
            for d in ${(s.:.)rhs}; do
                [[ -z "$d" || "$d" == '$PATH' ]] && continue
                if ! grep -qxF "$d" "$pathfile" 2>/dev/null; then
                    print -r -- "$d" >> "$pathfile"
                    print -P "%F{green}→ PATH dir moved to path.d/injected.path:%f $d"
                fi
            done
        elif [[ "$line" == export\ * ]]; then
            print -r -- "$line" >> "$dotfiles/env.zsh"
            print -P "%F{green}→ env export moved to env.zsh:%f $line"
        else
            unhandled+="$line"$'\n'
        fi
    done <<< "$injected"

    # Truncate the file to everything up to and including the sentinel.
    local tmp; tmp="$(mktemp)"
    awk -v s="$_ZSHRC_SENTINEL" '{print} $0==s{exit}' "$f" > "$tmp" && mv "$tmp" "$f"

    if [[ -n "${unhandled//[$'\n\t ']/}" ]]; then
        print -P "%F{yellow}⚠ Could not classify these lines — handle manually:%f"
        print -r -- "$unhandled"
    fi

    $was_locked && chflags uchg "$f"
    print -P "%F{green}✓ Healed. Re-source with: source ~/.zshrc%f"
}

get_java_home() {
    # Picks the newest JDK 21 dir under core-public/tools/Darwin/jdk that has a
    # working bin/java. Core's bazel toolchain pins onejdk_21 (see
    # core/.bazelrc and tools/build/bazel/sfdc/java/toolchains.bzl), so we
    # match both naming schemes the build uses: openjdk_21.* and
    # sfdc-jdk-zulu-21.*. Empty/half-populated dirs are skipped.
    local base_dir="${CORE_WORKSPACE:-/opt/workspace/core-public}/tools/Darwin/jdk"

    if [ ! -d "$base_dir" ]; then
        echo "Error: Directory $base_dir not found."
        return 1
    fi

    local d
    for d in $(ls -dt "$base_dir"/openjdk_21.*_aarch64 "$base_dir"/sfdc-jdk-zulu-21.*_aarch64 2>/dev/null); do
        if [ -x "$d/bin/java" ]; then
            basename "$d"
            return 0
        fi
    done

    echo "No usable JDK 21 found in $base_dir."
    return 1
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
