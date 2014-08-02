# vim: ft=sh
#
# some more ls aliases
alias ll='ls -Xlh --group-directories-first'
alias la='ls -XA --group-directories-first'
alias l='ls -XCF --group-directories-first'

#alias sysupdate='sudo apt-get update && sudo apt-get dist-upgrade -u'

#alias starttitan="VBoxHeadless --startvm debian_lenny &"
#alias killtitan="VBoxManage controlvm debian_lenny poweroff"

alias gvim="gvim --remote-silent"

alias sa="screen -raAd"
alias ta="tmux attach -d"
alias tmux="TERM=screen-256color tmux"

#alias mountorion="sshfs orion: ~/orion/"
#alias unmountorion="fusermount -u ~/orion/"

alias ccb="ledger -c bal checking liabilities:mastercard bank:savings \
assets:cash liabilities:govt"

alias cfb="ledger bal checking liabilities:mastercard bank:savings \
assets:cash liabilities:govt"

alias cab="ledger bal checking liabilities:mastercard bank:savings \
assets:cash liabilities:govt assets:portfolio:cash"

alias getpodcasts="gpo update && gpo download"
alias getcleared="ledger --cleared bal liabilities:mastercard checking"
alias networth="ledger -V --price-db ~/finances/prices.db bal \
    assets:portfolio liabilities:mastercard bank:savings assets:cash \
    bank:checking"

alias edch="vim ~/finances/2014_checking.ldg"
alias edmc="vim ~/finances/2014_mastercard.ldg"
alias edin="vim ~/finances/2014_investments.ldg"

alias gedch="gvim ~/finances/2014_checking.ldg"
alias gedmc="gvim ~/finances/2014_mastercard.ldg"
alias gedin="gvim ~/finances/2014_investments.ldg"

alias ..="cd .."
alias c='clear'
alias df='df -h'
alias mkdir='mkdir -pv'
alias mount='mount |column -t'
alias h='history'
alias edit='vim'
alias st2='sublime-text-2'
alias restart='sudo shutdown -r now'

alias irssi="TERM=screen-256color irssi"


alias ping='ping -c 5'
alias apt-get='sudo apt-get'
alias ac="apt-cache"

alias psx="ps auxw | grep $1"

alias startdelta="VBoxHeadless --startvm freebsd &"
alias killdelta="VBoxManage controlvm freebsd acpipowerbutton"
alias delta="ssh jsjones@delta"

alias awsconnect="ssh -i ~/.ec2/ec2.pem ubuntu@ec2-54-244-136-14.us-west-2.compute.amazonaws.com"

alias cinnamon-restart='cinnamon --replace -d :0.0 >/dev/null 2>&1 &'
alias android_dev="sh ~/android-studio/bin/studio.sh &"
alias java-dev="sh ~/bin/intellijIDEA/bin/idea.sh &"
