#!/bin/sh

SESSION_NAME=sandbox

tmux has-session -t $SESSION_NAME 2>/dev/null

# if session does not already exist, go ahead and set up
if [ $? != 0 ]; then
    tmux -2 new-session -d -s $SESSION_NAME

    # Window 1: scratch window
    tmux rename-window "scratch"

    # Window 2: notes
    tmux new-window -n "ledgers"
    tmux send-key "cd $HOME/ledgers" C-m

    # Window 3: notes
    tmux new-window -n "notes"
    tmux send-key "cd $HOME/notes" C-m

    # Switch to window 1 at start
    tmux select-window -t $SESSION_NAME:1
fi

tmux -2 attach-session -t $SESSION_NAME

