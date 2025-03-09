#!/bin/sh

SESSION_NAME=core-env
GIT_CORE_DIR="/opt/workspace/core-public/core"
GIT_SOMA_DIR="$HOME/projects/git-soma"
SFDX_PROJ_DIR="$HOME/projects/sfdx-projects"

if [[ ! -d "$GIT_CORE_DIR" ]]; then
    echo "Workstation is not set up for core-git..."
    exit 1
fi

tmux has-session -t $SESSION_NAME 2>/dev/null

# if session does not already exist, go ahead and set up
if [ $? != 0 ]; then
    tmux -2 new-session -d -s $SESSION_NAME

    # Window 1: scratch window
    tmux rename-window "scratch"
    tmux send-key "cd" C-m

    # Window 2: build tasks
    tmux new-window -n "build tasks" -c $GIT_CORE_DIR

    # Window 3: server tasks
    tmux new-window -n "core server" -c $GIT_CORE_DIR

    # Window 4: git chores
    tmux new-window -n "git chores" -c $GIT_CORE_DIR

    # Window 5: git soma projects
    tmux new-window -n "webruntime" -c $GIT_SOMA_DIR/webruntime

    # Window 6: sfdx projects
    tmux new-window -n "sf projects" -c $SFDX_PROJ_DIR

    tmux select-window -t $SESSION_NAME:1
fi

tmux -2 attach-session -t $SESSION_NAME

