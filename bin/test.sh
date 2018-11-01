# if [[ -z "$AUDIO_OUTPUT" ]]; then
#     export AUDIO_OUTPUT="SPEAKERS"
# fi 

# if [[ "$AUDIO_OUTPUT" = "SPEAKERS" ]]; then
#     alsactl restore -f $HOME/.config/alsa/headphones.profile
#     export AUDIO_OUTPUT="HEADPHONES"
# else
#     alsactl restore -f $HOME/.config/alsa/speakers.profile
#     export AUDIO_OUTPUT="SPEAKERS"
# fi
