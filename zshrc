if [ "$(arch)" = 'i386' ]; then
  [ -e /usr/local/bin/brew ] && eval "$(/usr/local/bin/brew shellenv)"
else # arch = arm64
  [ -e /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

cdpath=(. $HOME/Projects/updater $HOME/Projects $HOME)
FPATH="$HOME/.dotfiles/zsh-completions/:${FPATH}"

if type brew &>/dev/null; then
  brew_installed="yes"
  brew_prefix=$(brew --prefix)
fi

if [ -n "$brew_installed" ]; then
  FPATH="${brew_prefix}/share/zsh/site-functions:${brew_prefix}/share/zsh-completions:${FPATH}"
fi

autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit
_comp_options+=(globdots)

HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
source $HOME/.dotfiles/zsh-plugins/zsh-histdb/sqlite-history.zsh 

_zsh_autosuggest_strategy_histdb_top_here() {
    local query="select commands.argv from
history left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir LIKE '$(sql_escape $PWD)%'
and commands.argv LIKE '$(sql_escape $1)%'
group by commands.argv order by count(*) desc limit 1"
    suggestion=$(_histdb_query "$query")
}

ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here

autoload -Uz add-zsh-hook

export CLICOLOR=true
export ERL_AFLAGS="-kernel shell_history enabled"
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export HTTPIE_CONFIG_DIR='~/.config/httpie'
export LC_CTYPE=$LANG
export LSCOLORS="exfxcxdxbxegedabagacad"
export PAGER=less
export TIME_STYLE=long-iso
export ZSH=$HOME/.dotfiles
#export GPG_TTY="$(tty)"
#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

#gpgconf --launch gpg-agent

if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
  export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
  alias emacs="$EMACS -nw"
fi

if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
  alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
  export VISUAL="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c"
  export EDITOR=$VISUAL
fi

# Set location of z installation
if [ -n "$brew_installed" ]; then
  . ${brew_prefix}/etc/profile.d/z.sh
fi

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
HISTSIZE=1000000
SAVEHIST=1000000

if [ -n "$brew_installed" ]; then
  [ -f $(brew --prefix asdf)/libexec/asdf.sh ] && source $(brew --prefix asdf)/libexec/asdf.sh
  [ -f ${brew_prefix}/etc/bash_completion.d/asdf.bash ] && source ${brew_prefix}/etc/bash_completion.d/asdf.bash
  [ -f ${brew_prefix}/etc/bash_completion.d/kubie.bash ] && source ${brew_prefix}/etc/bash_completion.d/kubie.bash
fi

[ -f ~/.asdf/plugins/java/set-java-home.zsh ] && source ~/.asdf/plugins/java/set-java-home.zsh
[ -f ~/.asdf/plugins/dotnet-core/set-dotnet-home.zsh ] && source ~/.asdf/plugins/dotnet-core/set-dotnet-home.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases

[ -x "$(command -v hub)" ] && eval "$(hub alias -s)"
[ -x "$(command -v kubectl)" ] && source <(kubectl completion zsh)
[ -x "$(command -v stern)" ] && source <(stern --completion=zsh)

direnv() {
  asdf exec direnv "$@"
}

export PATH="${brew_prefix}/opt/gnu-sed/libexec/gnubin:${brew_prefix}/opt/curl-openssl/bin:${brew_prefix}/sbin:$PATH:$(go env GOPATH)/bin:$HOME/.dotnet/tools:$HOME/.bin:$HOME/.rd/bin"

update_dotnet_home() {
  local dotnet_path
  dotnet_base="$(dotnet --info | grep "Base Path" | awk '{print $3}')"
  if [[ -n "${dotnet_base}" ]]; then
    export DOTNET_BASE="${dotnet_base}"
    export DOTNET_ROOT=$(echo $DOTNET_BASE | sed -E "s/^(.*)(\/sdk\/[^\/]+\/)$/\1/")
    export MSBuildSDKsPath=${DOTNET_BASE}Sdks/ 
  fi
}

update_dotnet_home

# add-zsh-hook precmd update_dotnet_home

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

eval "$(asdf exec direnv hook zsh)"
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

# kubernetes
alias knetdebug='kubectl run -i --tty --rm clr-tempshell --image=nicolaka/netshoot -- /bin/bash'

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

#######################
# MUST BE LOADED LAST #
#######################
source ${brew_prefix}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${brew_prefix}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
#######################
# MUST BE LOADED LAST #
#######################

neofetch
