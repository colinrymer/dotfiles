export ZSH=$HOME/.dotfiles

# make things colorful
autoload -U colors && colors
source `brew --prefix`/etc/grc.bashrc

fpath=($ZSH/zsh/completions $fpath)

autoload -U compinit
compinit

# source every .zsh file in this rep
for config_file ($ZSH/**/*.zsh) source $config_file
# source every .aliases file in this rep
source $ZSH/aliases
# load every completion after autocomplete loads
#for config_file ($ZSH/**/*.completion) source $config_file

