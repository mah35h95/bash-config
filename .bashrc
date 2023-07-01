#!/usr/bin/bash

#* custome prompt function
function __set_my_refined_prompt {
    #? previous_command_status - pcs
    local pcs=$?

    #* To update the history from any place bash is opened
    history -a

    #* defining color constants
    local RED="\033[0;31m"
    local GREEN="\033[0;32m"
    local NOCOLOR="\033[0m"
    local YELLOW="\033[0;33m"
    local BLACK="\033[0;30m"
    local PURPLE="\033[0;35m"
    local WHITE="\033[0;37m"
    local BLUE="\033[0;34m"
    local CYAN="\033[0;36m"
    local GREY="\033[0;90m"

    local pcsc="\[${PURPLE}\]"
    if [ $pcs -ne 0 ]; then
        pcsc="\[${RED}\]"
    fi

    PS1="\n\[${GREEN}\]\u \[${NOCOLOR}\]💻 \[${GREY}\]\h \[${BLUE}\]$PWD\[${CYAN}\]$(__git_ps1)\n$pcsc❯\[${NOCOLOR}\] "
}
PROMPT_COMMAND='__set_my_refined_prompt'

#* random meme printer function
# random=$RANDOM
random=$$ #? PID of shell is stored in $$ variable and $RANDOM also contains the same value
function __show_a_meme {
    folder_path=~/.bash-config/ascii_memes
    file_count=$(ls $folder_path | wc -l) #? returns the number of files in a directory
    file_name="$folder_path/$(($random % $file_count)).txt"
    random=$(($random + 1))

    #? print while startup if file exists
    test -f $file_name && cat $file_name
}

#* Control History to ignore dups and earase dups
export HISTCONTROL=ignoredups:erasedups

#* To update the history from any place bash is opened
unset HISTFILESIZE
HISTSIZE=3000
export HISTSIZE PROMPT_COMMAND
shopt -s histappend

#* Show the meme on start up
__show_a_meme
