# vim: ft=sh
#
# some more ls aliases
alias ls='ls -X --color=auto'
alias ll='ls -Xlh --group-directories-first'
alias la='ls -XAh --group-directories-first'
alias lal='ls -XAlh --group-directories-first'
alias l='ls -XCF --group-directories-first'
alias dir='ls --color=auto --format=vertical'
alias grep='grep --color=auto'

#alias sysupdate='sudo apt-get update && sudo apt-get dist-upgrade -u'

#alias starttitan="VBoxHeadless --startvm debian_lenny &"
#alias killtitan="VBoxManage controlvm debian_lenny poweroff"

alias gvim="gvim --remote-silent"

alias sa="screen -raAd"
alias ta="tmux attach -d"
alias tmux="TERM=screen-256color tmux"

#alias mountorion="sshfs orion: ~/orion/"
#alias unmountorion="fusermount -u ~/orion/"

alias ccb="ledger -c bal checking liabilities:mastercard \
    liabilities:visa bank:savings \
    assets:cash liabilities:govt"

alias cfb="ledger bal checking liabilities:mastercard \
    liabilities:visa bank:savings \
    assets:cash liabilities:govt"

alias cab="ledger bal checking liabilities:mastercard bank:savings \
assets:cash liabilities:govt assets:portfolio:cash"

alias getpodcasts="gpo update && gpo download"
alias getcleared="ledger --cleared bal liabilities:mastercard liabilities:visa checking"
alias networth="ledger -V --price-db ~/finances/prices.db bal \
    assets:portfolio liabilities:mastercard liabilities:visa \
    bank:savings assets:cash bank:checking"

alias edch="vim ~/finances/2016_checking.ldg"
alias edmc="vim ~/finances/2016_mastercard.ldg"
alias edv="vim ~/finances/2016_visa.ldg"
alias edin="vim ~/finances/2016_investments.ldg"

alias gedch="gvim ~/finances/2016_checking.ldg"
alias gedmc="gvim ~/finances/2016_mastercard.ldg"
alias gedv="gvim ~/finances/2016_visa.ldg"
alias gedin="gvim ~/finances/2016_investments.ldg"

alias ..="cd .."
alias c='clear'
alias df='df -h'
alias mkdir='mkdir -pv'
alias mount='mount |column -t'
alias h='history'
alias edit='vim'
alias restart='sudo shutdown -r now'

alias irssi="TERM=screen-256color irssi"


alias ping='ping -c 5'
alias apt-get='sudo apt-get'
alias ac="apt-cache"

alias psx="ps auxw | grep $1"

alias startdelta="VBoxHeadless --startvm freebsd &"
alias killdelta="VBoxManage controlvm freebsd acpipowerbutton"
alias delta="ssh jsjones@delta"
alias startubuntu="VBoxHeadless --startvm ubuntu1510 &"
alias killubuntu="VBoxManage controlvm ubuntu1510 acpipowerbutton"
alias startcentos="VBoxHeadless --startvm Centos7 &"
alias killcentos="VBoxManage controlvm Centos7 acpipowerbutton"

alias awsconnect="ssh -i ~/.ec2/ec2.pem ubuntu@ec2-54-244-136-14.us-west-2.compute.amazonaws.com"

alias cinnamon-restart='cinnamon --replace -d :0.0 >/dev/null 2>&1 &'
alias android="sh ~/android-studio/bin/studio.sh &"
alias intellij="sh ~/dev/intellij/idea-IC-141.713.2/bin/idea.sh &"
alias webstorm="sh ~/dev/WebStorm-141.1237/bin/webstorm.sh &"
alias koding='ssh -i ~/.ssh/id_rsa-vms jsj0nes@ujkk08e7bae9.jsj0nes.koding.io'
alias bs='browser-sync start --server --port 3001 --files="./*"'
alias startjekyll='cd $HOME/projects/githubpages && bundle exec jekyll serve --drafts --watch'
