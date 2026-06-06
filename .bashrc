#!/usr/bin/bash

#* Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

#* clean bash_history
function __clean_up {
    current_path=$(pwd)
    cd ~/.bash-config

    cat cmd.txt >> ../.bash_history

    awk 'BEGIN{FS=":"}
            FNR==NR {for (i=1; i<=NF; i++) {dup[$i]++; last[$i]=NR;} next}
            /^$/ {next}
            {for (i=1; i<=NF; i++)
                if (dup[$i] && FNR==last[$i]) {print $0; next}}
            ' ../.bash_history ../.bash_history >bash_history.txt
    
    cp bash_history.txt ../.bash_history
    rm bash_history.txt

    cd "$current_path"
}

#* open gcp
function __open_gcp {
    projects=("dev-0349-gkesharedclus-000403" "dev-2134-entdatalake-83100d" "dev-2135-entdatahub-3e44fa" "dev-2136-entanalytics-7e43a7" "dev-2362-entdatasrvs-995ba1" "dev-2367-entdataingst-5a9bf0" "dev-2384-entdatatransfm-382c7c legacy" "dev-2384-entdatatransfm-c47ee7" "dev-2395-entdatagoverna-419052" "dev-2409-interimanalyti-3127d5" "dev-2433-crudsanalctrl-40c870" "dev-2434-entdataingests-539db3" "dev-2510-datasec-4d9350" "dev-2599-globalhub-02d1c9" "dev-2622-globalana-0f08d9" "dev-2735-fivetran-453619" "dev-2763-entdatawh-591612" "dev-3064-open-metadata-4c99d9" "dev-host-501b6298bea22651" "lab-atp-374297" "monitoring-2134-entdata-95894c" "monitoring-2367-entdata-0133e5" "prep-0349-gkesharedclus-44eed9" "prep-2134-entdatalake-969cbf" "prep-2135-entdatahub-550e42" "prep-2136-entanalytics-abf90b" "prep-2362-entdatasrvs-9f4bbf" "prep-2367-entdataingst-804660" "prep-2384-entdatatransf-7b3806 legacy" "prep-2384-entdatatransf-fea86a" "prep-2409-interimanalyt-1b2176" "prep-2433-crudsanalctrl-8c6f22" "prep-2434-entdataingest-137cde" "prep-2510-datasec-3d3459" "prep-2599-globalhub-5266b4" "prep-2622-globalana-cf55b5" "prep-2763-entdatawh-dfd90e" "prep-3064-open-metadata-1166bd" "preprod-2395-entdatagov-6da195" "preprod-host-501b6298bea22651" "prod-0349-gkesharedclus-207bfe" "prod-2134-entdatalake-5938ee" "prod-2135-entdatahub-a44fd9" "prod-2136-entanalytics-a35bea" "prod-2362-entdatasrvs-12372d" "prod-2367-entdataingst-7010d5" "prod-2384-entdatatransf-4ca949 legacy" "prod-2384-entdatatransf-eea4ff" "prod-2395-entdatagovern-17b55b" "prod-2409-interimanalyt-f31d34" "prod-2433-crudsanalctrl-a56704" "prod-2434-entdataingest-05104f" "prod-2510-datasec-d69e00" "prod-2599-globalhub-631979" "prod-2622-globalana-9c8936" "prod-2735-fivetran-380609" "prod-2763-entdatawh-bb5597" "prod-3064-open-metadata-66e218" "prod-host-501b6298bea22651" "qa-0349-gkesharedclus-23d50f" "qa-2134-entdatalake-d057be" "qa-2135-entdatahub-b2b0ac" "qa-2136-entanalytics-5129c5" "qa-2362-entdatasrvs-e0388a" "qa-2367-entdataingst-c1271b" "qa-2384-entdatatransfm-5b5d48" "qa-2384-entdatatransfm-783234 legacy" "qa-2395-entdatagovernan-86f62a" "qa-2409-interimanalytic-b8f1ba" "qa-2433-crudsanalctrl-737c44" "qa-2434-entdataingestst-221259" "qa-2510-datasec-c8b5e0" "qa-2599-globalhub-86f1b4" "qa-2622-globalana-9c74c2" "qa-2735-fivetran-e9061d" "qa-2763-entdatawh-8878e8" "qa-3064-open-metadata-3e5542" "qa-host-501b6298bea22651")
    project=$(printf "%s\n" "${projects[@]}" | fzf)
    project=$(echo "$project" | perl -pe 's/ \w+//g')

    services=("home/dashboard" "bigquery" "bigquery/policy-tags" "appengine" "appengine/versions" "iam-admin/iam" "storage/browser" "run" "firestore/databases" "logs/query" "logs/router" "cloudscheduler" "kubernetes/list/overview" "cloudpubsub/topic/list" "cloudpubsub/subscription/list" "dataflow/jobs" "functions" "artifacts" "cloudtasks" "composer/environments")
    service=$(printf "%s\n" "${services[@]}" | fzf)

    if [[ "${service}" == "" ]]; then
        exit 0
    fi

    start "https://console.cloud.google.com/$service?project=$project"
}

#* custom prompt function
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

    PS1="\n\[${GREEN}\]\u \[${NOCOLOR}\]💻 \[${GREY}\]\h \[${BLUE}\]$PWD\[${CYAN}\]$(GIT_PS1_SHOWUNTRACKEDFILES=1 GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)\n$pcsc❯\[${NOCOLOR}\] "
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
HISTSIZE=10000
export HISTSIZE PROMPT_COMMAND
shopt -s histappend

#? Aliases
#* Directory
alias la='ls -al'
#* mpv
alias mpv='mpv.exe'
alias mpvf='video_file=$(fzf) && mpv.exe "$video_file" && echo "$video_file"'
alias frm='rm_file=$(fzf) && rm "$rm_file" && echo "Deleted $rm_file"'
#* ble.sh - https://github.com/akinomyoga/ble.sh?tab=readme-ov-file#quick-instructions
alias af="source ~/.local/share/blesh/ble.sh"

#* Show the meme on start up
__show_a_meme
