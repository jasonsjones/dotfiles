#!/bin/bash
#
# tmux-session.sh — launch or attach predefined tmux sessions.
#
# Usage: tmux-session.sh <session> [<session>...]
#        tmux-session.sh all [--attach <session>]
#        tmux-session.sh --list
#
# When multiple sessions are given (or `all` is used), each missing session is
# built in turn. The script then attaches/switches to the last session named —
# or, with `--attach <name>`, to that one. With `all`, the default attach
# target is `sandbox` (matching the most common workflow).
#
# Each session is defined by a function `session_<name>` that emits one window
# per line in the format:
#
#   <window-name>|<start-dir>|<initial-command>
#
# Empty <start-dir> means use tmux's default. Empty <initial-command> means no
# command is sent. The first line listed becomes the active window on attach.

set -eu

# ----- session definitions ---------------------------------------------------

session_on_core() {
    core_dir="/opt/workspace/core-public/core"
    if [ ! -d "$core_dir" ]; then
        echo "Workstation is not set up for core-git ($core_dir not found)" >&2
        return 1
    fi
    cat <<EOF
scratch||cd
build tasks|$core_dir|
core server|$core_dir|
git chores|$core_dir|
claude|$core_dir|
EOF
}

session_off_core() {
    sfdx_dir="$HOME/projects/sf-projects"
    cat <<EOF
scratch||cd
webruntime|/opt/workspace/webruntime|
sf projects|$sfdx_dir|
EOF
}

session_sandbox() {
    cat <<EOF
scratch||
ledgers||cd $HOME/ledgers
notes||cd $HOME/notes
EOF
}

session_second_brains() {
    brains_dir="$HOME/projects/second-brains"
    cat <<EOF
arc lwr|$brains_dir/arc-lwr-second-brain|
arc aura|$brains_dir/arc-aura-second-brain|
arc trust|$brains_dir/arc-trust-second-brain|
EOF
}

# ----- session registry ------------------------------------------------------

# Add new sessions here. Keep the list and the dispatcher in sync.
SESSION_NAMES="sandbox on-core off-core second-brains"

# Default attach target when `all` is invoked without --attach.
ALL_DEFAULT_ATTACH="sandbox"

dispatch() {
    case "$1" in
        sandbox)  session_sandbox ;;
        on-core)  session_on_core ;;
        off-core) session_off_core ;;
        second-brains) session_second_brains ;;
        *)        return 1 ;;
    esac
}

# ----- runtime ---------------------------------------------------------------

usage() {
    prog="$(basename "$0")"
    cat <<EOF
Usage: $prog <session> [<session>...]
       $prog all [--attach <session>]
       $prog --list

Available sessions:
EOF
    for name in $SESSION_NAMES; do echo "  $name"; done
}

list_sessions() {
    for name in $SESSION_NAMES; do echo "$name"; done
}

build_session() {
    session_name="$1"

    # Capture the window definitions before creating the session — if the
    # definition function fails (e.g. missing directory), don't leave a
    # half-built session behind.
    windows="$(dispatch "$session_name")"

    # Start the session in the first window's directory so window 1 lands in
    # the right place (new-session has no per-window -c fix-up below).
    first_dir=""
    while IFS='|' read -r _name _start_dir _init_cmd; do
        case "$_name" in
            ''|\#*) continue ;;
        esac
        first_dir="$_start_dir"
        break
    done <<EOF
$windows
EOF

    if [ -n "$first_dir" ]; then
        tmux -2 new-session -d -s "$session_name" -c "$first_dir"
    else
        tmux -2 new-session -d -s "$session_name"
    fi

    # Honor whatever base-index the user has configured (commonly 1).
    base_index="$(tmux show-options -gv base-index 2>/dev/null || echo 0)"

    first=1
    idx="$base_index"
    while IFS='|' read -r name start_dir init_cmd; do
        # Skip blank lines and comments.
        case "$name" in
            ''|\#*) continue ;;
        esac

        if [ "$first" -eq 1 ]; then
            tmux rename-window -t "$session_name:$idx" "$name"
            first=0
        else
            if [ -n "$start_dir" ]; then
                tmux new-window -t "$session_name:" -n "$name" -c "$start_dir"
            else
                tmux new-window -t "$session_name:" -n "$name"
            fi
        fi

        if [ -n "$init_cmd" ]; then
            tmux send-keys -t "$session_name:$idx" "$init_cmd" C-m
        fi

        idx=$((idx + 1))
    done <<EOF
$windows
EOF

    # Activate the first window.
    tmux select-window -t "$session_name:$base_index"
}

is_known_session() {
    for name in $SESSION_NAMES; do
        [ "$name" = "$1" ] && return 0
    done
    return 1
}

ensure_session() {
    session_name="$1"
    if ! tmux has-session -t="$session_name" 2>/dev/null; then
        build_session "$session_name"
    fi
}

main() {
    if [ $# -lt 1 ]; then
        usage >&2
        exit 1
    fi

    case "$1" in
        -h|--help) usage; exit 0 ;;
        -l|--list) list_sessions; exit 0 ;;
    esac

    if ! command -v tmux >/dev/null 2>&1; then
        echo "tmux is not installed or not on PATH" >&2
        exit 1
    fi

    # Parse arguments into a list of session names + an optional attach target.
    targets=""
    attach_override=""
    used_all=0
    while [ $# -gt 0 ]; do
        case "$1" in
            --attach)
                if [ $# -lt 2 ]; then
                    echo "--attach requires a session name" >&2
                    exit 1
                fi
                attach_override="$2"
                shift 2
                ;;
            all)
                used_all=1
                targets="$targets $SESSION_NAMES"
                shift
                ;;
            -*)
                echo "Unknown flag: $1" >&2
                usage >&2
                exit 1
                ;;
            *)
                if ! is_known_session "$1"; then
                    echo "Unknown session: $1" >&2
                    usage >&2
                    exit 1
                fi
                targets="$targets $1"
                shift
                ;;
        esac
    done

    # Normalize to positional args (collapses leading/duplicate whitespace).
    set -- $targets
    if [ $# -eq 0 ]; then
        echo "No sessions specified" >&2
        usage >&2
        exit 1
    fi

    # Decide attach target: explicit --attach wins, else `all` defaults to the
    # configured default, else the last positional name.
    if [ -n "$attach_override" ]; then
        if ! is_known_session "$attach_override"; then
            echo "Unknown --attach session: $attach_override" >&2
            exit 1
        fi
        attach_target="$attach_override"
    elif [ "$used_all" -eq 1 ]; then
        attach_target="$ALL_DEFAULT_ATTACH"
    else
        for t in "$@"; do attach_target="$t"; done
    fi

    # Build any sessions that don't yet exist (in the order given).
    for session_name in "$@"; do
        ensure_session "$session_name"
    done

    if [ -n "${TMUX:-}" ]; then
        # Already inside tmux — switch instead of nesting.
        tmux switch-client -t "$attach_target"
    else
        tmux -2 attach-session -t "$attach_target"
    fi
}

main "$@"
