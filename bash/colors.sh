# colors.sh 
#
# Custom color setting for bash prompt
# The default settings are initially provided 
# below and will be overridden if changed.
# Removing a value will restore the default value.
#
# Must be located in the [Dotfiles dir]/bash/ dir
# to properly work.
#
# Colin Rymer 12/6/11

COLOR_ONE=$(tput setaf 99)     # magenta
COLOR_TWO=$(tput setaf 122)   # orange
COLOR_THREE=$(tput setaf 10) # green
COLOR_FOUR=$(tput setaf 141)  # purple
COLOR_FIVE=$(tput setaf 254)  # white
COLOR_SIX=$(tput setaf 256)   # clear (on my macbook - should be white)
RUBY=$(tput setaf 200)        # ruby prompt color
GEMSET=$(tput setaf 123)      # gemset color
