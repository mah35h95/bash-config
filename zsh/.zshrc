#* oh-my-zsh configuration
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions fast-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

#* user configuration

# export MANPATH="/usr/local/man:$MANPATH"
export GOBIN=/Users/gm/go/bin
export PATH=$PATH:$GOBIN:/Users/gm/.spicetify

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#* custom functions

#* clean bash_history
function __clean_up {
    current_path=$(pwd)
    cd ~

    awk 'BEGIN{FS=":"}
            FNR==NR {for (i=1; i<=NF; i++) {dup[$i]++; last[$i]=NR;} next}
            /^$/ {next}
            {for (i=1; i<=NF; i++)
                if (dup[$i] && FNR==last[$i]) {print $0; next}}
            ' ./.bash_history ./.bash_history >bash_history.txt
    
    cp bash_history.txt ./.bash_history
    rm bash_history.txt

    cd "$current_path"
}

#* clean zsh_history
function __clean_up_zsh {
    epoch_at_clean=$(date +%s)

    current_path=$(pwd)
    cd ~

    # replace epoch time in each line set by oh-my-zsh with current epoch time 
    sed -r -i '' -e "s/^: [0-9]+:[0-9]+;/: $(echo $epoch_at_clean):0;/g" ./.zsh_history

    # set the split the same as the new epoch time that is set above
    # sort .zsh_history file and copy uniques into zsh_history.txt
    awk 'BEGIN{FS=": $(echo $epoch_at_clean):0;"}
            FNR==NR {for (i=1; i<=NF; i++) {dup[$i]++; last[$i]=NR;} next}
            /^$/ {next}
            {for (i=1; i<=NF; i++)
                if (dup[$i] && FNR==last[$i]) {print $0; next}}
            ' ./.zsh_history ./.zsh_history >zsh_history.txt
    
    cp zsh_history.txt ./.zsh_history
    rm zsh_history.txt

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

#* random meme printer
# random=$RANDOM
random=$$ #? PID of shell is stored in $$ variable and $RANDOM also contains the same value
function __show_a_meme {
    folder_path=~/dev/random-dev/bash-config/ascii_memes
    file_count=$(ls $folder_path | wc -l) #? returns the number of files in a directory
    file_name="$folder_path/$(($random % $file_count)).txt"
    random=$(($random + 1))

    #? print while startup if file exists
    test -f $file_name && cat $file_name
}

#* starship (shell prompt design manager)
eval "$(starship init zsh)"

#* mise (toolchain manager)
eval "$(/Users/gm/.local/bin/mise activate zsh)"

#* fzf (fuzzy finder)
source <(fzf --zsh)

#* jujutsu (version controller)
autoload -U compinit
compinit
source <(jj util completion zsh)


#* gcloud (GCP cli tool)
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/gm/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/gm/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/gm/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/gm/google-cloud-sdk/completion.zsh.inc'; fi

#* Show the meme on start up
__show_a_meme
