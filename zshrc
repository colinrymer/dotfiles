autoload -U colors && colors

fpath=($ZSH/zsh/completions $fpath)
autoload -U compinit && compinit

for config_file ($ZSH/**/*.zsh) source $config_file

chruby $(< ~/.global-ruby-version)
chnode $(< ~/.global-node-version)

export PATH="$HOME/.yarn/bin:$PATH"
