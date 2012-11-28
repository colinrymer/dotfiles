autoload colors && colors
autoload spectrum && spectrum

# set VIMODE according to the current mode (default “[i]”)
VIMODE='-- INSERT --'
function zle-keymap-select {
 VIMODE="${${KEYMAP/vicmd/}/(main|viins)/-- INSERT --}"
 zle reset-prompt
}

function zle-line-finish {
 VIMODE='-- INSERT --'
}

zle -N zle-keymap-select
zle -N zle-line-finish

parse_git_dirty(){
  [[ $(git status 4> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}

parse_git_branch(){
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

git_status(){
  if [ -d .git ]; then
    echo "%{$FG[254]%}on %{$FG[141]%}$(parse_git_branch)%{$reset_color%}"
  fi;
}

directory_name(){
  echo "%{$FG[190]%}${PWD/#$HOME/~}%{$reset_color%}"
}

user_and_host(){
  echo "%{$FG[009]%}%n%{$reset_color%}%{$FG[254]%}@%{$reset_color%}%{$FG[172]%}%m%{$reset_color%}"
}

ruby_version(){
  echo "%{$FG[200]%}Ruby `ruby -e 'print "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"'`%{$reset_color%}"
}


# not used with rbenv
#gemset_name(){
  #echo "%{$FG[123]%}`rvm gemset name`%{$reset_color%}"
#}

export PROMPT=$'\n$(user_and_host)%{$FG[254]%} in $(directory_name) $(git_status) %{$FG[254]%}using $(ruby_version)%{$FG[254]%}%{$reset_color%}\n\$ '

export RPROMPT=$'%{$FG[077]%}${VIMODE}%{$reset_color%}'

dong_it(){
	echo `dong -lx ~/.zdong`
}

#export RPROMPT='$(dong_it)'
