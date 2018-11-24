#!/usr/bin/sh

# x86_energy_perf_policy --all balance-power

# Start Redshift with manual location as Detroit
redshift -l 42.33143:-83.04575 &> /dev/null &

# Start clipmenu dameon
clipmenud &

# Start xscreensaver daemon
xscreensaver &

# Lock on suspend
xss-lock -- /usr/bin/xscreensaver-command -lock &

# Start night theme
xrdb $HOME/.Xresources-night
feh --bg-fill $HOME/pics/wallpaper-night.jpg

# Start emacs
emacs --daemon

# Start keyboard shortcut manager
sxhkd &

# Start window compositor
compton -b --config $HOME/.config/compton.conf 

# Start window manager
exec bspwm -c $HOME/.config/bspwm/bspwmrc
