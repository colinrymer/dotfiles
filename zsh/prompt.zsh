autoload colors && colors
autoload spectrum && spectrum

# set VIMODE according to the current mode (default “-- INSERT --”)
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

git_info(){
  if [[ "$(git_path)" != '' ]]; then
    echo "%{$FG[254]%}on %{$FG[141]%}$(git_branch)%{$FG[254]%}@%{$FG[032]%}$(git_commit_id)%{$FG[095]%}$(git_rebase)%{$FG[084]%}$(git_dirty)%{$reset_color%}"
  fi
}

directory_name(){
  echo "%{$FG[190]%}${PWD/#$HOME/~}%{$reset_color%}"
}

user_and_host(){
  echo "%{$FG[009]%}%n%{$reset_color%}%{$FG[254]%}@%{$reset_color%}%{$FG[172]%}%m%{$reset_color%}"
}

ruby_version(){
  echo "%{$FG[200]%}Ruby $(rbenv version | cut -d' ' -f 1)%{$reset_color%}"
}

export PROMPT=$'\n$(user_and_host)%{$FG[254]%} in $(directory_name) $(git_info) %{$FG[254]%}using $(ruby_version)%{$FG[254]%}%{$reset_color%}\n\$ '

export RPROMPT=$'%{$FG[077]%}${VIMODE}%{$reset_color%}'
