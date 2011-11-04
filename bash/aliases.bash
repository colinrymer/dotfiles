#-------------------
# Personal Aliases
#-------------------

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

alias bye='logout'

alias sickbeard='python ~/Sick-Beard/SickBeard.py -d'

alias netlogon="sudo sysctl -w net.inet.ip.fw.verbose=1"
alias netlogoff="sudo sysctl -w net.inet.ip.fw.verbose=0"

alias gemit="rvm gem install"

alias ls='ls -A -G'
alias ll='ls -l -g'

alias ..='cd ..'
alias ~='cd ~'
alias h='cd ~'

nsm () { nasm -f elf -o "$1".o -l "$1".l "$1".s;}

#-------------------------------------------------------------
# spelling typos - highly personal and keyboard-dependent :-)
#-------------------------------------------------------------

alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias puhs='push'