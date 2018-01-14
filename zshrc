zmodload zsh/zprof
autoload -U colors && colors

export VISUAL="/usr/local/bin/emacsclient"
export EDITOR=$VISUAL

export ZSH=$HOME/.dotfiles

export GOPATH=~/Projects/gocode

export HTTPIE_CONFIG_DIR='~/.config/httpie'

export BABEL_CACHE_PATH=~/cache/babel.json
export YARN_CACHE_FOLDER=~/cache/yarn

export PAGER=less
export LC_CTYPE=$LANG
export TIME_STYLE=long-iso

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:.git/safe/../../bin:$GOPATH/bin:$PATH"

fpath=($ZSH/zsh/completions $fpath)
autoload -U compinit && compinit

source $ZSH/zsh/aliases.zsh
source $ZSH/zsh/async.zsh
source $ZSH/zsh/aws.zsh
source $ZSH/zsh/completion.zsh
source $ZSH/zsh/config.zsh
source $ZSH/zsh/directories.zsh
source $ZSH/zsh/edit-command-line.zsh
source $ZSH/zsh/fancy_ctrl_z.zsh
source $ZSH/zsh/prompt.zsh

source /usr/local/opt/asdf/asdf.sh
source /usr/local/etc/bash_completion.d/asdf.bash

source <(kubectl completion zsh)

eval "$(hub alias -s)"
eval "$($HOME/Projects/rentpath/idg/bin/idg init -)"

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/zsh/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
