# Sexy Bash Prompt, inspired by "Extravagant Zsh Prompt"
# Screenshot: http://img.gf3.ca/d54942f474256ec26a49893681c49b5a.png
# A big thanks to \amethyst on Freenode

if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      # set defaults
      COLOR_ONE=$(tput setaf 9)     # magenta
      COLOR_TWO=$(tput setaf 172)   # orange
      COLOR_THREE=$(tput setaf 190) # green
      COLOR_FOUR=$(tput setaf 141)  # purple
      COLOR_FIVE=$(tput setaf 254)  # white
      COLOR_SIX=$(tput setaf 256)   # clear (on my macbook - should be white)
      RUBY=$(tput setaf 200)        # ruby prompt color
      GEMSET=$(tput setaf 123)      # gemset color

      # load custom settings - would like to remove hard-coding
      source $BSH/bash/colors.sh 

    else
      COLOR_ONE=$(tput setaf 5)
      COLOR_TWO=$(tput setaf 4)
      COLOR_THREE=$(tput setaf 2)
      COLOR_FOUR=$(tput setaf 1)
      COLOR_FIVE=$(tput setaf 7)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
fi

parse_git_dirty () {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
parse_git_branch () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

PS1="\[${COLOR_ONE}\]\u\[$COLOR_FIVE\]@\[$COLOR_TWO\]\h \[$COLOR_FIVE\]in \[$COLOR_THREE\]\w\[$COLOR_FIVE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$COLOR_FOUR\]\$(parse_git_branch)\[$COLOR_FIVE\] using \[$RUBY\]Ruby \$(ruby -e 'print RUBY_VERSION')\[$COLOR_FIVE\], gemset \[$GEMSET\]\$(rvm gemset name)\n\[$RESET\]\$ "
