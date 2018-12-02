if [ "$1" = "next" ]; then
    echo '{ "command": ["playlist-next", "weak"] }' | socat - /tmp/mpvsocket
    GET $(avahi-resolve -n banana.local | cut -d $'\t' -f2)"/api/v1/commands?cmd=next"
elif [ "$1" = "prev" ]; then
    echo '{ "command": ["playlist-prev", "weak"] }' | socat - /tmp/mpvsocket
    GET $(avahi-resolve -n banana.local | cut -d $'\t' -f2)"/api/v1/commands?cmd=prev"
elif [ "$1" = "stop" ]; then
    echo '{ "command": ["cycle", "quit"] }' | socat - /tmp/mpvsocket
    GET $(avahi-resolve -n banana.local | cut -d $'\t' -f2)"/api/v1/commands?cmd=stop"
elif [ "$1" = "toggle" ]; then
    echo '{ "command": ["cycle", "pause"] }' | socat - /tmp/mpvsocket
    GET $(avahi-resolve -n banana.local | cut -d $'\t' -f2)"/api/v1/commands?cmd=toggle"
else
    echo "Command not recognized"
fi
