# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# stuff from kyle wheeler's bashrc file.
JSJDEBUG=${JSJDEBUG:-no}

function dprint {
if [[ $JSJDEBUG == yes && $- == *i* ]]; then
    date "+%H:%M:%S $*"
    echo $SECONDS $*
fi
}

#dprint alive

if [ -r "${HOME}/.bashrc.local.preload" ]; then
    dprint "Loading bashrc preload"
    source "${HOME}/.bashrc.local.preload"
fi

# ANSI color codes
RS="\[\033[0m\]"    # reset
HC="\[\033[1m\]"    # bold
UL="\[\033[4m\]"    # underline

INV="\[\033[7m\]"   # inverse background and foreground

FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[32m\]" # foreground green
FYEL="\[\033[33m\]" # foreground yellow
FBLE="\[\033[34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white

BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLE="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#xterm-color)
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#    ;;
#*)
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#    ;;
#esac

export GIT_PS1_SHOWDIRTYSTATE=1

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

PS1="$HC$FGRN\u$RS$FWHT on $HC$FYEL\h$RS$FWHT at $HC$FCYN\w$FMAG\$(__git_ps1)$FBLE\n\\$ $RS"
#PS1='\u@\h \w$(__git_ps1)\$'
PS2="$HC$FBLE> $RS"


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls -X --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias grep='grep --color=auto'
    #alias vdir='ls --color=auto --format=long'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# added by jsjones
if [ -f ~/.bash_task_completion ]; then
    source ~/.bash_task_completion
fi

if [ -f ~/.git-completion ]; then
    source ~/.git-completion
fi

set -o vi
shopt -s cdspell

echo -e "Welcome to the terminal...$USER"
echo 'This is where the fun starts!...(read from ~/.bashrc)'
echo 'Type: "sysupdate" to run apt-get update && dist-upgrade -u'
echo $(date)

source /home/jsjones/bin/functions


export PATH=$PATH:/home/jsjones/bin:/home/jsjones/bin/SynologyAssistant/:/home/jsjones/bin/android-sdk-linux/tools:/usr/local/bin:/home/jsjones/google_appengine
export MANPATH=$MANPATH:.:/home/jsjones/src/man:
export TERM="xterm-256color"
export EDITOR="vim"
export PRINTER="PSC-2350-series"
export DEBFULLNAME="Jason Jones"
export DEBEMAIL="jsjones96@gmail.com"
export GIT_EDITOR="vim"
export LEDGER="~/finances/master_ledger.ldg"
export LEDGER_PRICE_DB="~/finances/prices.db"


export CLASSPATH=$CLASSPATH:~/src/algs4/stdlib.jar:~/src/algs4/algs4.jar
test -r ~/src/algs4/bin/config.sh && source ~/src/algs4/bin/config.sh

