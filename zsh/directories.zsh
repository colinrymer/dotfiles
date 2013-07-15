# Changing/making/removing directory
setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups

setopt auto_cd
cdpath=(. $HOME $HOME/Projects/sites $HOME/Projects/primedia $HOME/Projects)

function ls_after_chpwd() {
  ls -la .
}

chpwd_functions=( ls_after_chpwd $chpwd_functions )

# mkdir & cd to it
function mcd() { 
  mkdir -p "$1" && cd "$1"; 
}
