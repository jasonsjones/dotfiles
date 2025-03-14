#!/bin/sh

SESSION_NAME=off-core
GIT_SOMA_DIR="$HOME/projects/git-soma"
SFDX_PROJ_DIR="$HOME/projects/sfdx-projects"

tmux has-session -t $SESSION_NAME 2>/dev/null

# if session does not already exist, go ahead and set up
if [ $? != 0 ]; then
    tmux -2 new-session -d -s $SESSION_NAME

    # Window: scratch window
    tmux rename-window "scratch"
    tmux send-key "cd" C-m

    # Window: git soma projects
    tmux new-window -n "webruntime" -c $GIT_SOMA_DIR/webruntime

    # Window: sfdx projects
    tmux new-window -n "sf projects" -c $SFDX_PROJ_DIR

    tmux select-window -t $SESSION_NAME:1
fi

tmux -2 attach-session -t $SESSION_NAME

