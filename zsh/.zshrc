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
export PATH=$PATH:/Users/gm/.spicetify
export GOBIN=/Users/gm/go/bin

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
