eval "$(direnv hook zsh)"

### This has to be after the direnv hook to fix a bug where the
### directory contents are printed multiple times.
function ls_after_chpwd() {
  ls -la .
}
chpwd_functions=( ls_after_chpwd $chpwd_functions )


