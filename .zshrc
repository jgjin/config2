# Try to use scoped vars in funcs

# Change and add
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=35;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=33:*.jpeg=33:*.gif=33:*.bmp=33:*.pbm=33:*.pgm=33:*.ppm=33:*.tga=33:*.xbm=33:*.xpm=33:*.tif=33:*.tiff=33:*.png=33:*.svg=33:*.svgz=33:*.mng=33:*.pcx=33:*.mov=33:*.mpg=33:*.mpeg=33:*.m2v=33:*.mkv=33:*.webm=33:*.ogm=33:*.mp4=33:*.m4v=33:*.mp4v=33:*.vob=33:*.qt=33:*.nuv=33:*.wmv=33:*.asf=33:*.rm=33:*.rmvb=33:*.flc=33:*.avi=33:*.fli=33:*.flv=33:*.gl=33:*.dl=33:*.xcf=33:*.xwd=33:*.yuv=33:*.cgm=33:*.emf=33:*.ogv=33:*.ogx=33:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*.org=45;36:*.log=30'

# Add completions
fpath=(~/.config/zsh/completions $fpath)

# Completion and initialization
zstyle ':completion:*' completer _expand _complete _ignored _match
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle :compinstall filename '/home/banana/.zshrc'

autoload -Uz compinit
compinit

# Shell variables
HEADPHONES_VOLUME=20
SPEAKERS_VOLUME=60
AUDIO_OUTPUT="SPEAKERS"
CUSTOM_RM_THRESHOLD=5
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
HISTORY_IGNORE="(cd*|ls*|clear|view*|findimg*|findviewsort*|gimp*|play*|man *|type *|rzsh|exit)"
PROMPT='%F{068}%n%f%F{029}@%f%F{134}%m%f %F{029}%~%f %F{068}%#%f '
setopt appendhistory autocd extendedglob HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_DUPS # NO_BEEP
bindkey -e

# Ignore duplicates when going back in history 
# https://github.com/zsh-users/zsh-history-substring-search/issues/19
if [[ -o HIST_FIND_NO_DUPS ]]; then
    local -A unique_matches
    for n in $_history_substring_search_matches; do
        unique_matches[${history[$n]}]="$n"
    done
    _history_substring_search_matches=(${(@no)unique_matches})
fi

# Environment variables
export CM_LAUNCHER='rofi'
export EDITOR='vim'
export GDK_SCALE=2
# export LD_LIBRARY_PATH="/usr/local/lib/"
export LS_COLORS
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.cask/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/go/bin"
# export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export VISUAL='vim'
export _Z_DATA="$HOME/.dir_history"

# Support history-based cd
. /usr/share/z/z.sh

# cd then ls to directory
cd_ls() {
    chdir $@
    custom_ls
}

# Custom functions
connect() {
    sudo netctl stop-all
    echo "Starting profile $1"
    sudo netctl start $1 || return 2
    echo "Waiting for profile $1 to go online"
    sudo netctl wait-online $1
    # # sleep 2
    # echo "Attempting to connect to routable IP"
    # ping -c 1 8.8.8.8 -W 15 # &> /dev/null
    # if [ "$?" -eq 0 ]; then
    # 	echo "Connecting to VPN"
    # 	gpg --decrypt $HOME/.config/vpn/credentials.gpg | sudo openconnect $VPN
    # 	return 0
    # fi
    # echo "Could not connect to routable IP, so not connecting to VPN"
    return 1
}

count() {
    NUM_FILES=`find $PWD -maxdepth 1 -type f | wc -l`
    NUM_DIRECTORIES=`find $PWD -maxdepth 1 -type d | wc -l`
    echo $NUM_FILES "files," $NUM_DIRECTORIES "directories"
}

# https://superuser.com/questions/611538/is-there-a-way-to-display-a-countdown-or-stopwatch-timer-in-a-terminal
# Start countdown from $1 seconds
countdown() {
    date1=$((`date +%s` + $1)); 
    while [ "$date1" -ge `date +%s` ]; do 
	echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
	sleep 0.1
    done
}

# cd if directory in current directory, otherwise move to directory based on history
custom_cd() {
    if [[ "$#" -eq 0 ]]; then
    	chdir $HOME
    else
	if [[ -d "$1" ]] || [[ "$1" = '-' ]]; then
	    chdir $1
	else
	    z $@ && echo $@ "found using z" || echo $@ "not found under either cd and z"
	fi
    fi
}

# ls with default preferred args into less if necessary
custom_ls() {
    TPUT_COLS=`tput cols`
    if /bin/ls -C --width $TPUT_COLS $@ > /tmp/ls.txt; then
	LS_LINES=`wc -l < /tmp/ls.txt`
	/usr/bin/rm /tmp/ls.txt
	TPUT_LINES=`tput lines`
	if [ "$LS_LINES" -gt "$TPUT_LINES" ]; then
	    /bin/ls --almost-all --classify --color=always -C --width $TPUT_COLS $@ | less -R
	else
	    /bin/ls --almost-all --classify --color=always -C --width $TPUT_COLS $@
	fi
    fi
}

# Add any special behavior for mv
custom_mv() {
    # if [ "$PWD" = '/home/banana/music' ]; then
    # 	echo "Please use movemusic"
    # else
    /usr/bin/mv -i $@
    # fi
}

# TODO: fix prompt not always appearing
# Warn if files more than CUSTOM_RM_THRESHOLD
custom_rm() {
    # if [ "$PWD" = '/home/banana/music' ]; then
    # 	echo "Please use removemusic"
    # else
    CUSTOM_RM_NUM=0
    for arg in "$@"; do
	if [ $arg[0,1] != '-' ]; then
	    if [ -d "$arg" ]; then
		find $arg -type f | sort > /tmp/custom_rm_$CUSTOM_RM_NUM.txt
	    else
                echo $arg > /tmp/custom_rm_$CUSTOM_RM_NUM.txt
	    fi
	    CUSTOM_RM_NUM=$(($CUSTOM_RM_NUM + 1))
	fi
    done
    if [ "$CUSTOM_RM_NUM" -gt 0 ]; then
	cat /tmp/custom_rm_*.txt > /tmp/custom_rm.txt
	/usr/bin/rm /tmp/custom_rm_*.txt
	CUSTOM_RM_FILES=`wc -l < /tmp/custom_rm.txt`
    else
	CUSTOM_RM_FILES=-1
    fi
    if [ "$CUSTOM_RM_FILES" -gt "$CUSTOM_RM_THRESHOLD" ]; then
	echo "rm $CUSTOM_RM_FILES files? "
	TPUT_LINES=`tput lines`
	if [ "$CUSTOM_RM_FILES" -gt "$TPUT_LINES" ]; then
	    cat /tmp/custom_rm.txt | less
	else
	    cat /tmp/custom_rm.txt
	fi
	/usr/bin/rm /tmp/custom_rm.txt
	local CUSTOM_RM_RESPONSE
	vared CUSTOM_RM_RESPONSE
	if [ "$CUSTOM_RM_RESPONSE" = 'y' ]; then
	    /usr/bin/rm $@
	else
	    echo "Aborted"
	fi
    else
	/usr/bin/rm -i $@
    fi
    # fi
}

# Report bspwm desktop layouts for all desktops
desktop_layouts() {
    for id in $(bspc query -D); do
	DESKTOP_JSON=`bspc query -d $id -T`
	DESKTOP_NAME=`echo $DESKTOP_JSON | jshon -e name`
        DESKTOP_LAYOUT=`echo $DESKTOP_JSON | jshon -e layout`
	echo $DESKTOP_NAME layout: $DESKTOP_LAYOUT
    done
}

# Execute du sorted by size
disk_usage() {
    du -hd1 $@ | sort -h
}

# Execute as emacsclient and background process
emacsclient_background() {
    emacsclient $@ &
}

# Find all images matching argument expression
find_img() {
    find $@ -type f > /tmp/img.txt
}

# Find all images with one or more provided words in name
find_img_set() {
    FIND_IMG_SET_NUM=0
    for word in "$@"; do
	find -type f -wholename "*$word*" ! -wholename "*old*" > /tmp/find_img_$FIND_IMG_SET_NUM.txt
	FIND_IMG_SET_NUM=$(($FIND_IMG_SET_NUM + 1))
    done
    cat /tmp/find_img_*.txt > /tmp/img.txt 
    rm -f /tmp/find_img_*.txt
}

# Find all images matching argument expression and view in sorted order
find_view_sort() {
    find_img $@
    view -f /tmp/img.txt --sort filename &
}

# Git commit files with changes
git_commit_diff() {
    COMMIT_FILES=$(git diff --name-only HEAD | tr '\n' ' ')
    eval "git commit $COMMIT_FILES"
}

# Diff $1 commits behind
git_diff() {
    git diff HEAD~$1
}

# Merge $1 commits behind
git_merge() {
    git rebase -i HEAD~$1
}

# mv album and run speed_up_albums
move_music() {
    mv $@
    cd ~/music
    speed_up_albums ~/music 1.40 ~/music/sped-up
    cd -
}

# Move then change to that directory
mv_cd() {
    custom_mv $@
    chdir "${@: -1}"
}

# Search pacman and print pkgfile suggestion if fails
pac_search() {
    pacman -Ss $@ || echo "No package found, maybe use pkgfile?"
}

# Play audio at 1.40x speed
play() {
    if [ "$1" -eq "$1" ] 2>/dev/null; then
	amixer -q sset Master $1%
	ARGS=${@:2}
    else
	ARGS=$@
    fi
    mpv --speed=1.40 --hwdec=auto --gapless-audio=yes --no-audio-display --input-ipc-server=/tmp/mpvsocket $ARGS
}

# Perform command ${@:2} on arguments matching regex $1
rec_regex() {
    COMMAND=${@:2}
    ARGS=$(ag --smart-case -g $1 | sed 's/ /\\ /g' | tr '\n' ' ')
    eval "$COMMAND $ARGS"
}

# rm album and rm sped-up/album
remove_music() {
    for album in "$@"; do
	read -k "rm -rf ~/music{,/sped-up}/$album? " REMOVE_MUSIC_RESPONSE
	if [[ "$REMOVE_MUSIC_RESPONSE" -eq 'y' ]]; then
	    rm -rf ~/music{,/sped-up}/$album
	fi
    done
}

# Speed up audio files in $1 by $2 into $3
speed_up_album() {
    if [ ! -d "$3" ]; then
	mkdir -p $3
    fi
    for INODE in $1/*; do
	BASE_NAME=$(basename $INODE)
	if [ -d "$INODE" ]; then
	    speed_up_album $INODE $2 $3/$BASE_NAME
	else
	    echo $3/$BASE_NAME
	    BIT_RATE=$(mediainfo $INODE | ag "Overall bit rate\s\s" | cut -d: -f2 | cut -d" " -f2)
	    if ! sox -G $INODE $3/$BASE_NAME tempo $2 rate -s -h -a 44100 dither -s 2> /dev/null; then
		ffmpeg -i $INODE -b:a $(($BIT_RATE * 1100)) -filter:a "atempo=$2" -vn $3/$BASE_NAME 2> /dev/null
	    fi
	fi
    done
}

# Speed up all files in directories in $1 by $2 into $3
speed_up_albums() {
    for INODE in $1/*; do
	if [ ! -d "$INODE" ]; then
	    echo $INODE "is file, skipping"
	else
	    BASE_NAME=$(basename $INODE)
	    if [ -d "$3/$BASE_NAME" ]; then
		echo $3/$BASE_NAME "already exists, skipping"
	    else
		if [ "$BASE_NAME" != "$3" -a "$BASE_NAME" != "tracklists" -a "$BASE_NAME" != "metadata" ]; then
		    speed_up_album $INODE $2 $3/$BASE_NAME
		fi
	    fi
	fi
    done
    echo "Filtered diff results:"
    diff -qr $1 $3 | ag "Only in" | ag "Only in $1: $3" --invert-match
}

# SSH into raspberry pi
ssh_rpi() {
    if [[ "$#" -eq 0 ]]; then
	ssh volumio@192.168.211.1
    else
	ssh volumio@$1
    fi
}

# Start stopwatch with hours, minutes, and seconds
stopwatch() {
    date1=`date +%s`; 
    while true; do 
	echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; 
	sleep 0.1
    done
}

# Update essential configuration at $HOME
update_config() {
    /usr/bin/ls ~/music > ~/album_list.txt
    pacman -Qqe > ~/package_list.txt
    /usr/bin/ls ~/aur > ~/aur_list.txt 
    chdir ~
    git_commit_diff
    chdir -
}

# Update music in Raspberry Pi
update_music() {
    if [[ "$#" -eq 0 ]]; then
	sudo rsync -rltuvP --delete ~/music/sped-up /mnt/sdcard/dyn/data/INTERNAL
	# rsync -avhru --delete --info=progress2 $HOME/music/sped-up volumio@192.168.1.146:/mnt/INTERNAL
    else
	# sudo rsync -rltuvP --delete ~/music/sped-up $@
	rsync -avhru --delete --info=progress2 $HOME/music/sped-up volumio@$1:/mnt/INTERNAL
    fi
}

# View pictures sorted by name in fullscreen without bar
view() {
    xdo lower -a "bar"
    feh --fullscreen --auto-zoom --image-bg black --quiet --fontpath /usr/share/fonts/TTF/ --menu-font "Roboto-Regular/24" $@
    if ! pidof "feh" > /dev/null; then 
	xdo raise -a "bar"
    fi
}

# View images with one or more provided words in name
view_set() {
    find_img_set $@
    view -f /tmp/img.txt --sort filename
}

# View all pictures in directory
view_all() {
    find_img .
    view -f /tmp/img.txt $@
}

# # Other configurations
# source $HOME/.config/postgres/config.sh
# source $HOME/.config/vpn/config.sh
source $HOME/.config/zsh/keybindings 

# Aliases
source $HOME/.aliases.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/banana/dls/google-cloud-sdk/path.zsh.inc' ]; then . '/home/banana/dls/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/banana/dls/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/banana/dls/google-cloud-sdk/completion.zsh.inc'; fi
