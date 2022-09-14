alias c="clear"
alias cat="bat --theme=TwoDark"
alias lg="lazygit"
alias vim="nvim"

alias setinternalregistry="npm config set registry https://nexus-proxy-prd.soma.salesforce.com/nexus/content/groups/npm-all/"
alias setpublicregistry="npm config set registry https://registry.npmjs.org/"

alias corepids="corecli core:ps | grep UP | awk '{print \$6}' | tr '\n' ' '"
alias glon='function _glon() { git log --oneline -n $1 }; _glon'

alias ccb="ledger -c bal checking liabilities:mastercard \
          liabilities:visa bank:savings assets:cash liabilities:'wells fargo' \
          Assets:Reimbursement:Home:Fence"
alias cfb="ledger bal checking liabilities:mastercard \
          liabilities:visa:joint liabilities:visa:usna bank:savings assets:cash"


# Old aliases
#alias zshconfig="code --new-window ~/.zshrc"

#alias wsm="ssh jasonjones-wsm"

#alias dckrstop="docker stop $(docker ps -aq)"
#alias dckrrm="docker rm $(docker ps -aq)"

#alias listglobalnpmpackages="npm list -g --depth=0"

#alias squashpr="git rebase -i HEAD~\$(git rev-list master.. --count)"

#alias code="code --new-window"
#alias notes="code --new-window ~/Documents/notes"
#alias scratchpad="code --new-window ~/Documents/notes ~/Documents/notes/scratch.md"

