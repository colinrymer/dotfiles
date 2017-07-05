autoload -U colors && colors

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

chruby $(< ~/.global-ruby-version)
chnode $(< ~/.global-node-version)

export PATH="$HOME/.yarn/bin:$PATH"

source <(kubectl completion zsh)

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/zsh/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#antigen bundle docker
#antigen bundle encode64
#antigen bundle httpie
#antigen bundle arialdomartini/oh-my-git
#antigen bundle zsh-users/zsh-autosuggestions
