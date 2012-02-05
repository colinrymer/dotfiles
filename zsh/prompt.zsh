autoload colors && colors
autoload spectrum && spectrum

parse_git_dirty(){
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit" ]] && echo "*"
}

parse_git_branch(){
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

git_status(){
  echo "%{$FG[254]%}on %{$FG[141]%}$(parse_git_branch)%{$reset_color%}"
}

directory_name(){
  echo "%{$FG[190]%}${PWD/#$HOME/~}%{$reset_color%}"
}

user_and_host(){
  echo "%{$FG[009]%}%n%{$reset_color%}%{$FG[254]%}@%{$reset_color%}%{$FG[172]%}%m%{$reset_color%}"
}

ruby_version(){
  echo "%{$FG[200]%}Ruby `ruby -e 'print RUBY_VERSION'`%{$reset_color%}"
}

gemset_name(){
  echo "%{$FG[123]%}`rvm gemset name`%{$reset_color%}"
}

export PROMPT=$'\n$(user_and_host)%{$FG[254]%} in $(directory_name) $(git_status) %{$FG[254]%}using $(ruby_version)%{$FG[254]%}, gemset $(gemset_name)%{$reset_color%}\n\$ '

export RPROMPT=''
