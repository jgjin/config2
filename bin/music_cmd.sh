if [ "$1" = "down" ]; then
    MUSIC_VOLUME=`echo '{ "command": ["get_property", "volume"] }' | socat - /tmp/mpvsocket | jshon -e "data"`
    echo '{ "command": ["set_property", "volume", "'$((`printf "%.0f" $MUSIC_VOLUME` - $2))'"] }' | socat - /tmp/mpvsocket
    MUSIC_VOLUME=`GET "192.168.1.146/api/v1/getstate" | jshon -e "volume"`
    GET "192.168.1.146/api/v1/commands?cmd=volume&volume="$((MUSIC_VOLUME - $2))
elif [ "$1" = "next" ]; then
    echo '{ "command": ["playlist-next", "weak"] }' | socat - /tmp/mpvsocket
    GET "192.168.1.146/api/v1/commands?cmd=next"
elif [ "$1" = "prev" ]; then
    echo '{ "command": ["playlist-prev", "weak"] }' | socat - /tmp/mpvsocket
    GET "192.168.1.146/api/v1/commands?cmd=prev"
elif [ "$1" = "stop" ]; then
    echo '{ "command": ["quit"] }' | socat - /tmp/mpvsocket
    GET "192.168.1.146/api/v1/commands?cmd=stop"
elif [ "$1" = "toggle" ]; then
    echo '{ "command": ["cycle", "pause"] }' | socat - /tmp/mpvsocket
    GET "192.168.1.146/api/v1/commands?cmd=toggle"
elif [ "$1" = "up" ]; then
    MUSIC_VOLUME=`echo '{ "command": ["get_property", "volume"] }' | socat - /tmp/mpvsocket | jshon -e "data"`
    echo '{ "command": ["set_property", "volume", "'$((`printf "%.0f" $MUSIC_VOLUME` + $2))'"] }' | socat - /tmp/mpvsocket
    MUSIC_VOLUME=`GET "192.168.1.146/api/v1/getstate" | jshon -e "volume"`
    GET "192.168.1.146/api/v1/commands?cmd=volume&volume="$((MUSIC_VOLUME + $2))
else
    echo "Command not recognized"
fi
