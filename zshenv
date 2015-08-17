# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

export GOPATH=~/Projects/gocode

export HTTPIE_CONFIG_DIR='~/.config/httpie'

export PAGER=less
export LC_CTYPE=$LANG

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:.git/safe/../../bin:/usr/local/share/npm/bin:$GOPATH/bin:$PATH"

source $(brew --prefix chruby)/share/chruby/chruby.sh
source $(brew --prefix chruby)/share/chruby/auto.sh

# Fix for zsh cd/chruby auto.sh execution priority issue
precmd_functions+=("chruby_auto")

chruby $(cat ~/.global-ruby-version)

$(boot2docker shellinit 2>/dev/null)

eval "$(hub alias -s)"

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
