#!/usr/bin/sh

killall lemonbar
$HOME/bin/bar-night.sh | lemonbar -f "Source Code Pro-24" -p &
emacsclient -e "(if (daemonp) (remove-hook 'after-make-frame-functions 'load-spacemacs-light-for-new-frames))"
emacsclient -e "(if (daemonp) (add-hook 'after-make-frame-functions 'load-spacemacs-dark-for-new-frames))"
emacsclient -e "(load-theme 'spacemacs-dark t)"
xrdb $HOME/.Xresources-night
# printf "\033]4;#202020\007"
# printf "\033]49;#202020\007"
# printf "\033]12;#bc6ec5\007"
feh --bg-fill $HOME/pics/wallpaper-night.jpg
# xdo lower -a bar
