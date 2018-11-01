#!/usr/bin/sh

killall lemonbar
$HOME/bin/bar-day.sh | lemonbar -f "Source Code Pro-24" -p &
emacsclient -e "(if (daemonp) (remove-hook 'after-make-frame-functions 'load-spacemacs-dark-for-new-frames))"
emacsclient -e "(if (daemonp) (add-hook 'after-make-frame-functions 'load-spacemacs-light-for-new-frames))"
emacsclient -e "(load-theme 'spacemacs-light t)"
xrdb $HOME/.Xresources-day
# printf "\033]4;#fff4ee\007"
# printf "\033]49;#fff4ee\007"
# printf "\033]12;#787697\007"
feh --bg-fill $HOME/pics/wallpaper-day.jpg 
# xdo lower -a bar
