autoload spectrum && spectrum

git_path(){
  echo $(git rev-parse --git-dir 2>/dev/null)
}

git_branch(){
  echo $(cat $(git_path)/HEAD | ack 'refs\/heads\/(.*)' --output='$1')
}

git_commit_id(){
  echo $(git rev-parse --short HEAD 2>/dev/null)
}

git_rebase(){
  if [[ -e "$(git_path)/BISECT_LOG" ]]; then
    echo '+bisect'
  elif [[ -e "$(git_path)/MERGE_HEAD" ]]; then
    echo '+merge'
  elif [[ -e "$(git_path)/rebase" ]] || [[ -e "$(git_path)/rebase-apply" ]] ||  [[ -e "$(git_path)/rebase-merge" ]] || [[ -e "$(git_path)/../.dotest" ]]; then
    echo '+rebase'
  fi
}

git_dirty(){
  if [[ "$(git_path)" != '.' ]]; then
    if [[ $(git ls-files -om --exclude-standard) != '' ]]; then
      echo "✗"
    fi
  fi
}

_ruby_version(){
    local _ruby
    _ruby="$(chruby |grep \* |tr -d '* ruby-')"
    if [[ $(chruby |grep -c \*) -eq 1 ]]; then
        echo ${_ruby}
    else
        echo "system"
    fi
}

_user_host_info(){
  echo "%{$FG[009]%}%n%{$reset_color%}%{$FG[254]%}@%{$reset_color%}%{$FG[172]%}%m%{$FG[254]%}"
}

_directory_info(){
  echo " in %{$FG[190]%}${PWD/#$HOME/~}%{$reset_color%}"
}

_git_info(){
  if [[ "$(git_path)" != '' ]]; then
    echo " %{$FG[254]%}on %{$FG[141]%}$(git_branch)%{$FG[254]%}@%{$FG[032]%}$(git_commit_id)%{$FG[095]%}$(git_rebase)%{$FG[084]%}$(git_dirty)%{$reset_color%}"
  fi
}

_ruby_info(){
  echo " %{$FG[254]%}using %{$FG[200]%}Ruby $(_ruby_version)%{$FG[254]%}"
}

export PROMPT=$'\n$(_user_host_info)$(_directory_info)$(_git_info)$(_ruby_info)%{$reset_color%}\n\$ '

export RPROMPT='[%D{%L:%M:%S %p}]'
