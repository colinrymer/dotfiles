alias reload!='. ~/.zshrc'

# boot2docker
alias btd="boot2docker"

# bundler
alias b="bundle"
alias be="bundle exec"

# colors
if [ "$TERM" != dumb ] && command -v grc >/dev/null 2>&1; then
    alias colourify="grc -es --colour=auto"
    alias configure='colourify ./configure'
    alias diff='colourify diff'
    alias make='colourify make'
    alias gcc='colourify gcc'
    alias g++='colourify g++'
    alias as='colourify as'
    alias gas='colourify gas'
    alias ld='colourify ld'
    alias netstat='colourify netstat'
    alias ping='colourify ping'
    alias traceroute='colourify /usr/sbin/traceroute'
    alias head='colourify head'
    alias tail='colourify tail'
    alias dig='colourify dig'
    alias mount='colourify mount'
    alias ps='colourify ps'
    alias mtr='colourify mtr'
    alias df='colourify df'
fi

# git
#alias gci="git pull --rebase && rake && git push"
alias push='git push'
alias pull='git smart-pull'
alias commit='git commit'
alias cam='git commit -a -m'
alias c='git commit -m'
alias s='git status'
alias gl="git log --graph --pretty=format':%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset'"
alias gco='git checkout'

# heroku
alias hlogs='heroku logs'
alias hp='git push heroku master'

# node
alias npm-exec='PATH=$(npm bin):$PATH'
alias ne='PATH=$(npm bin):$PATH'

# rails
alias migrate="rake db:migrate db:rollback && rake db:migrate"
alias m="migrate"
alias rk="rake"
alias dms="rake db:reset"
alias rs="rails s"
alias rc="rails c"
alias rt="rake test"

# unix
alias z='fg'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir="mkdir -p"

alias l='ls -la'
alias ls='ls -A -G'
alias lsa='ls -lah'

alias h='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias tlf="tail -f"
alias ln="ln -v"
alias e='$EDITOR'
alias v='$VISUAL'

# vagrant
alias vs="vagrant status"
alias vu="vagrant up"
alias vp="vagrant provision"

# typos
alias puhs='push'
alias psuh='push'
alias sl=ls

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# Include custom aliases
[[ -f ~/.aliases.local ]] && source ~/.aliases.local

