export ZSH=$HOME/.dotfiles

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

# source every .zsh file in this rep
for config_file ($ZSH/**/*.zsh) source $config_file
# source every .aliases file in this rep
source $ZSH/aliases
# load every completion after autocomplete loads
#for config_file ($ZSH/**/*.completion) source $config_file

