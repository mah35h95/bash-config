# Control History to ignore dups and earase dups
export HISTCONTROL=ignoredups:erasedups

# To update the history from any place bash is opened
unset HISTFILESIZE
HISTSIZE=3000
# PROMPT_COMMAND="history -a"
export HISTSIZE # PROMPT_COMMAND
shopt -s histappend

# custome prompt function
# Bash: when in a git repository, show the current branch, indicate if the working directory is clean or not.
function __set_my_prompt {
    # previous_command_status - pcs
    local pcs=$?

    history -a
    # defining color constants
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

    # local git_modified_color="\[${GREEN}\]"
    # local git_status=$(git status 2>/dev/null | grep "Your branch is ahead" 2>/dev/null)
    # if [ "$git_status" != "" ]; then
    #     git_modified_color="\[${YELLOW}\]"
    # fi
    # local git_status=$(git status --porcelain 2>/dev/null)
    # if [ "$git_status" != "" ]; then
    #     git_modified_color="\[${RED}\]"
    # fi

    # local git_branch=$(git branch --show-current 2>/dev/null)
    # if [ "$git_branch" != "" ]; then
    #     git_branch="($git_modified_color$git_branch\[${BLACK}\]) "
    # fi
    # PS1="\[${BLACK}\]\u@\h \w $git_branch$\[${NOCOLOR}\] "

    # check if previous command status was successful i.e.0
    # previous_command_status_color - pcsc
    local pcsc="\[${PURPLE}\]"
    if [ $pcs -ne 0 ]; then
        pcsc="\[${RED}\]"
    fi

    # export PS1="\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n$ " #default PS1 value
    # export PS1="\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u\[\033[37m\]@\[\033[35m\]\h \[\033[33m\]$PWD\[\033[36m\]$(__git_ps1)\[\033[0m\]\n❯ "
    # PS1="\n\[${GREEN}\]\u\[${WHITE}\]@\[${GREY}\]\h \[${BLUE}\]\w\[${CYAN}\]$(__git_ps1)\n$pcsc❯\[${NOCOLOR}\] "
    PS1="\n\[${GREEN}\]\u 💻 \[${GREY}\]\h \[${BLUE}\]\w\[${CYAN}\]$(__git_ps1)\n$pcsc❯\[${NOCOLOR}\] "
}

PROMPT_COMMAND='__set_my_prompt'

file_count=$(ls ./ascii_memes | wc -l) # returns the number of files in a directory
random=$$                              # PID of shell is stored in $$ variable
file_name="./ascii_memes/$(($random % $file_count)).txt"

# print while startup if file exists
test -f $file_name && cat $file_name
