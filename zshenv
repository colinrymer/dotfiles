export VISUAL="/usr/local/bin/emacsclient"
export EDITOR=$VISUAL

export ZSH=$HOME/.dotfiles

export GOPATH=~/Projects/gocode

export HTTPIE_CONFIG_DIR='~/.config/httpie'

export PAGER=less
export LC_CTYPE=$LANG

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:.git/safe/../../bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$GOPATH/bin:$PATH"

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
source ~/Projects/chnode/share/chnode/chnode.sh
source ~/Projects/chnode/share/chnode/auto.sh

# Fix for zsh cd/chruby/chnode auto.sh execution priority issue
precmd_functions+=("chruby_auto")
precmd_functions+=("chnode_auto")

#chruby $(< ~/.global-ruby-version)
#chnode $(< ~/.global-node-version)

eval "$(hub alias -s)"

eval "$($HOME/Projects/rentpath/idg/bin/idg init -)"

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
