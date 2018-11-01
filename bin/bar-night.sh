#!/usr/bin/sh

# Based on http://blog.z3bra.org/2014/04/meeting-at-the-bar.html

# Print mpv track
mpv_track() {
    echo '{ "command": ["get_property", "filename"] }' | socat - /tmp/mpvsocket | jshon -e data |
	head -1 | cut -d- -f2 | cut -d' ' -f2- | cut -d. -f1 |
	sed -e 's/([^()]*)//g' -e 's/\[[^][]*\]//g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

# Print date and time
date_time() {
    date '+%Y-%m-%d %H:%M'
}

# Print battery status and capacity
battery() {
    BATTERY_STATUS=`cat /sys/class/power_supply/BAT0/status`
    BATTERY_CAPACITY=`cat /sys/class/power_supply/BAT0/capacity`
    
    echo $(echo $BATTERY_STATUS | cut -c1)$(printf "%03d" $BATTERY_CAPACITY)"%"
}

# Print volume level
volume() {
    amixer get Master | grep 'off' &> /dev/null
    if [ $? == 0 ]; then
	VOLUME_PREFIX="M"
    else
	VOLUME_PREFIX="U"
    fi
    printf "$VOLUME_PREFIX%03d%%" $(amixer get Master | sed -n 'N;s/^.*\[\([0-9]\+%\).*$/\1/p' | rev | cut -c2- | rev)
}

# Print CPU load
cpu() {
    # Load is divided by 4 because laptop has 4 cores
    ps -eo pcpu | awk 'BEGIN {sum=0.0f} {sum+=$1/4} END {printf "%03d", sum}'
}

# Print network connection state
network() {
    ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "C" || echo "D"
}

# Print desktops
desktops() {
    CURRENT_DESKTOP=`xprop -root _NET_CURRENT_DESKTOP | awk '{print ($3 + 1) % 10}'`
    NUMBER_DESKTOPS=`xprop -root _NET_NUMBER_OF_DESKTOPS | awk '{print $3}'`

    if [[ "$CURRENT_DESKTOP" -eq "0" ]]; then
	echo "%{F#d75fd7}[0] %{F#268bd2}1 2 3 4 5 6 7 8 9";
    elif [[ "$CURRENT_DESKTOP" -eq "9" ]]; then
	echo "0 1 2 3 4 5 6 7 8 %{F#d75fd7}[9]";
    else
	DESKTOPS=""
	for DESKTOP in `seq 0 $((CURRENT_DESKTOP - 1))`; do DESKTOPS+="$DESKTOP "; done
	DESKTOPS+="%{F#d75fd7}[$CURRENT_DESKTOP] %{F#268bd2}"
	for DESKTOP in `seq $((CURRENT_DESKTOP + 1)) 8`; do DESKTOPS+="$DESKTOP "; done
	DESKTOPS+="9"
	echo $DESKTOPS
    fi
}

# Aggregate information from functions above into stdout
while :; do
    if [[ "$(pidof mpv)" -eq "" ]]; then
	LINE="%{c}%{B#1c1c1c}"
    else
	LINE="%{l}%{F#268bd2}MUS: %{F#d75fd7}$(mpv_track)%{c}%{B#1c1c1c}"
    fi
    LINE="${LINE}%{F#268bd2}CLK: %{F#d75fd7}$(date_time) %{F#008787}| "
    LINE="${LINE}%{F#268bd2}BAT: %{F#d75fd7}$(battery) %{F#008787}| "
    LINE="${LINE}%{F#268bd2}VOL: %{F#d75fd7}$(volume) %{F#008787}| "
    LINE="${LINE}%{F#268bd2}CPU: %{F#d75fd7}$(cpu)% %{F#008787}| "
    LINE="${LINE}%{F#268bd2}NET: %{F#d75fd7}$(network) %{F#008787}| "
    LINE="${LINE}%{F#268bd2}WDW: $(desktops)"
    echo $LINE
    sleep 1
done
