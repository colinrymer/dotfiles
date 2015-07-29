# Changing/making/removing directory
setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups

setopt auto_cd
cdpath=(. $HOME/Projects/sites $HOME/Projects/spartan $HOME/Projects $HOME)

# mkdir & cd to it
function mcd() { 
  mkdir -p "$1" && cd "$1"; 
}

eval "$(direnv hook zsh)"

### This has to be after the direnv hook to fix a bug where the
### directory contents are printed multiple times.
function ls_after_chpwd() {
  ls -lah .
}
chpwd_functions=( ls_after_chpwd $chpwd_functions )


