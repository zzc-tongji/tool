# ~/.zprofile: executed by the command interpreter "zsh" for login shells.

# by default, "zsh" will NOT read "~/.profile", call it here
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi
