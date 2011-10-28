# Colin's dotfiles

## dotfiles

This is my collection of dotfiles, as inspired by Zack Holman, Ryan Bates, Eric Haughee, and random posts on the web. This uses the [implementation designed by Zach Holman](https://github.com/holman/dotfiles), but is focused on bash. Merging of a fork of his work is likely in the near future, since I'd like to start using zsh and some vim.

## installation

To install, you must have rake installed on your machine. You can test for rake with the command `rake -V`. RVM is highly recommended.

  1. `git clone git@github.com:crymer11/dotfiles.git ~/.dotfiles`
  2. `cd ~/.dotfiles`
  3. `rake install`

Any files ending in ".symlink" will be appropriately linked in the home directory (files beginning with a "." will not be symlinked).

### uninstall

To uninstall this setup:

  1. `cd ~/.dotfiles`
  2. `rake uninstall`

All the symlinks created by `rake install` will be removed and any backups made during the installation will be replaced. 

## ooh, secrets

The .gitignore file includes a line that ignores anything in a "secrets" directory. I use this to store anything private.

## thanks

Major thanks to [Zach Holman](https://github.com/holman/), from whom I borrowed heavily. [Eric Haughee](https://github.com/ehaughee) also provided me with the intial .bash_profile upgrades that prompted this project and can still be seen in my prompt.