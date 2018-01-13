export VISUAL="/usr/local/bin/emacsclient"
export EDITOR=$VISUAL

export ZSH=$HOME/.dotfiles

export GOPATH=~/Projects/gocode

export HTTPIE_CONFIG_DIR='~/.config/httpie'

export PAGER=less
export LC_CTYPE=$LANG
export TIME_STYLE=long-iso

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:.git/safe/../../bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$GOPATH/bin:$PATH"

eval "$(hub alias -s)"

eval "$($HOME/Projects/rentpath/idg/bin/idg init -)"

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
