cdpath=(. $HOME/Projects/updater $HOME/Projects/sites $HOME/Projects $HOME)
fpath=(/usr/local/Homebrew/completions/zsh/ /usr/local/share/zsh-completions $fpath)

autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit
_comp_options+=(globdots)

export BABEL_CACHE_PATH=~/cache/babel.json
export CLICOLOR=true
export ERL_AFLAGS="-kernel shell_history enabled"
export GOPATH=~/Projects/gocode
export HTTPIE_CONFIG_DIR='~/.config/httpie'
export LC_CTYPE=$LANG
export LSCOLORS="exfxcxdxbxegedabagacad"
export PAGER=less
export TIME_STYLE=long-iso
export ZSH=$HOME/.dotfiles
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

gpgconf --launch gpg-agent

if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
  export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
  alias emacs="$EMACS -nw"
fi

if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
  alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
  export VISUAL="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c"
  export EDITOR=$VISUAL
fi

export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Set location of z installation
. /usr/local/etc/profile.d/z.sh

# f [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
f() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR} "${files[@]}"
}
ff() {
  local files
  IFS=$'\n' files=($(fzf --preview 'head -100 {}' --exit-0))
  [[ -n "$files" ]] && ${EDITOR} "${files[@]}"
}

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

source /usr/local/opt/asdf/asdf.sh
source /usr/local/etc/bash_completion.d/asdf.bash
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f /usr/local/etc/bash_completion.d/az ] && source /usr/local/etc/bash_completion.d/az

source <(kubectl completion zsh)
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases

eval "$(hub alias -s)"

export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/curl-openssl/bin:$PATH:$(go env GOPATH)/bin"

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol

setopt always_to_end
setopt append_history
setopt auto_cd
setopt auto_menu         # show completion menu on succesive tab press
setopt auto_name_dirs
setopt auto_pushd
setopt cdablevars
#setopt complete_aliases
setopt complete_in_word
setopt correct
setopt extended_history # add timestamps to history
setopt ignore_eof
setopt inc_append_history
setopt local_options # allow functions to have local options
setopt local_traps # allow functions to have local traps
setopt long_list_jobs
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt no_bg_nice # don't nice background tasks
setopt no_hup
setopt no_list_beep
setopt prompt_subst
setopt pushd_ignore_dups
setopt share_history # share history between sessions ???

WORDCHARS=''

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# use /etc/hosts and known_hosts for hostname completion
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_global_ssh_hosts[@]"
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  "$HOST"
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1

if [ "x$COMPLETION_WAITING_DOTS" = "xtrue" ]; then
  expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots
fi

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

function mcd() { 
    mkdir -p "$1" && cd "$1"; 
}

function ls_after_chpwd() {
    colorls --sd -la
}

fancy-ctrl-z () {
    if [[ $#BUFFER -eq 0 ]]; then
        fg
        zle redisplay
    else
        zle push-input
        zle clear-screen
    fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

bindkey -e
# Make the delete key (or Fn + Delete on the Mac) work instead of outputting a ~
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char

eval "$(direnv hook zsh)"
### This has to be after the direnv hook to fix a bug where the
### directory contents are printed multiple times.
chpwd_functions=( ls_after_chpwd $chpwd_functions )

alias reload!='. ~/.zshrc'

# colors
if [ "$TERM" != dumb ] && command -v grc >/dev/null 2>&1; then
    alias colourify="grc -es --colour=auto"
    alias make='colourify make'
    alias netstat='colourify netstat'
    alias ping='colourify ping'
    alias traceroute='colourify /usr/sbin/traceroute'
    alias dig='colourify dig'
    alias mount='colourify mount'
    alias ps='colourify ps'
fi

# git
alias push='git push'
alias pull='git smart-pull'
alias cam='git commit -a -m'
alias s='git status'
alias gl="git log --graph --pretty=format':%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset'"
alias gco='git checkout'

# unix
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir="mkdir -p"

alias l='ls -la'
alias ls='ls -A -G'

alias h='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ln="ln -v"

alias cat='bat'

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

eval "$(starship init zsh)"

function awssession {
    unset AWS_SESSION_TOKEN
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    output=`aws sts get-session-token \                                                                                                                                                                                                       
      --serial-number arn:aws:iam::887744313716:mfa/colin.rymer@updater.com \                                                                                                                                                                
      --token-code $1 \                                                                                                                                                                                                                       
      --duration-seconds 43200`
    secret=`echo $output | jq '.Credentials.SecretAccessKey'`
    secret="${secret%\"}"
    secret="${secret#\"}"
    access=`echo $output | jq '.Credentials.AccessKeyId'`
    access="${access%\"}"
    access="${access#\"}"
    sessionToken=`echo $output | jq '.Credentials.SessionToken'`
    sessionToken="${sessionToken%\"}"
    sessionToken="${sessionToken#\"}"
    export AWS_SESSION_TOKEN=$sessionToken
    export AWS_ACCESS_KEY_ID=$access
    export AWS_SECRET_ACCESS_KEY=$secret
    echo "Session Token Expires at:"
    echo $output | jq '.Credentials.Expiration'
}

#######################
# MUST BE LOADED LAST #
#######################
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
#######################
# MUST BE LOADED LAST #
#######################

neofetch

