#!/bin/sh

SESSION_NAME=on-core
GIT_CORE_DIR="/opt/workspace/core-public/core"

if [[ ! -d "$GIT_CORE_DIR" ]]; then
    echo "Workstation is not set up for core-git..."
    exit 1
fi

tmux has-session -t $SESSION_NAME 2>/dev/null

# if session does not already exist, go ahead and set up
if [ $? != 0 ]; then
    tmux -2 new-session -d -s $SESSION_NAME

    # Window: scratch window
    tmux rename-window "scratch"
    tmux send-key "cd" C-m

    # Window 2: build tasks
    tmux new-window -n "build tasks" -c $GIT_CORE_DIR

    # Window: server tasks
    tmux new-window -n "core server" -c $GIT_CORE_DIR

    # Window: git chores
    tmux new-window -n "git chores" -c $GIT_CORE_DIR

    tmux select-window -t $SESSION_NAME:1
fi

tmux -2 attach-session -t $SESSION_NAME

