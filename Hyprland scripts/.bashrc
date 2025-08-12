# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
# Source custom command completions
if [ -d ~/.bash_completion.d ]; then
    for file in ~/.bash_completion.d/*.sh; do
        [ -r "$file" ] && source "$file"
    done
fi

# User specific environment
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export CMAKE_MAKE_PROGRAM=ninja
# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

unset rc
# Initialize zoxide and fzf with the bash  , zoxide hellps to auto jumps and add directory to its database 
eval "$(zoxide init bash)"
export _ZO_DATA_DIR=/home/asdf/zoxide
export FZF_DEFAULT_COMMAND='ls -1'
export FZF_DEFAULT_OPTS="--layout=reverse --info=inline"
export FZF_DEFAULT_OPTS_FILE="$HOME/.fzf_defaults"
export FZF_DEFAULT_OPTS_FILE=/home/asdf/.fzf-defaults
export _ZO_ECHO='1'
export TERM=xterm-256color
export PATH=$PATH:/var/lib/snapd/snap/bin
export $(dbus-launch)
export TZ="Asia/Kolkata"
date '+%b %d (%a) %I:%M%p'
export GTK_THEME=Adwaita:dark
eval "$(mcfly init bash)"
alias neo='nvim ~/.config/nvim/init.lua'
alias zeb-duke='blueman-manager'
alias s='. ~/.bashrc'
alias c='clear'
alias vi='sudo -E nvim'
alias ls='exa -all'
alias ll='exa -l'
alias la='exa -la'
alias lla='exa -la --git'
alias lt='exa -T'
alias vi=' nvim'
alias grep='grep --color=auto'
alias vbash='nvim ~/.bashrc'
alias zdata='zoxide edit'
alias diskspace="du -S | sort -n -r |more"
alias remove_with_dependency="sudo pacman -Rns"
alias iinstall="sudo pacman -S"
alias psg='ps aux | grep'
alias ip='ip addr show | grep inet'
alias vv='source ~/Desktop/virtualpy/bin/activate'
#system monitoring 
alias topcpu='top -o %CPU'
alias topmem='top -o %MEM'
alias watchdisk='watch -n 5 df -h'
alias meminfo='cat /proc/meminfo'
#KERNAL RELATED 
alias kernel='uname -r'        # Show kernel version
alias sysinfo='hostnamectl'    # Show system info
alias uinfo='lsb_release -a'   # Show distribution info (if available)
alias sensors='sensors'        # Show sensor information (requires lm_sensors)
alias back-one='git reset --hard '
# docker aliases 
alias docker_images='sudo docker images'
alias cd..='cd ..'
alias connect=" iwctl station wlan0 connect"
alias disconnect=" iwctl station wlan0 disconnect"


..() { cd "$(eval printf '../%.0s' {1..$1})" || return 1; }




# wifi 
#wifi iwd module , and  iwctl is the command
# to connect use iwctl station wlan0 connect ssid 
iwctl station wlan0 get-networks
# iwctl station wlan0 scan 


 printf "\n connect: use 'iwctl station wlan0 connect <SSID>'\n"

# cheat sheet 
cht(){ 
    curl "cheat.sh/$1" 
}

extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
netinfo ()
{
echo "--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
echo "${myip}"
echo "---------------------------------------------------"
}



speedtest() {
    curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
}



google() {
  # Replace these with your actual Google API key and Custom Search Engine ID
  local api_key="AIzaSyC_CLBRGCDosY9r9nog7RhkGvOjUtnjfNY"
  local cx="d7f8aa1cd5d1c4adc"

  # Join all arguments into a single search query
  local query="$*"

  # URL encode the query
  local encoded_query=$(echo "$query" | jq -sRr @uri)

  # Make a request to the Google Custom Search JSON API
  local response=$(curl -s "https://www.googleapis.com/customsearch/v1?key=${api_key}&cx=${cx}&q=${encoded_query}")

  # Extract the titles and links from the response
  echo "$response" | jq -r '.items[] | "\(.title)\n\(.link)\n"'
}



system_health() {
    echo "Disk Usage:"
    df -h
    echo ""
    echo "Memory Usage:"
    free -h
    echo ""
    echo "CPU Load:"
    uptime
}




envr() {
    echo "------------------------------------------"
    echo -e "\033[1;36mEnvironment Variables:\033[0m"  # Cyan title
    echo "------------------------------------------"
    
    printenv | awk -F= '{printf "\033[1;34m%-30s\033[0m = \033[1;32m%s\033[0m\n", $1, $2}'  # Blue keys, Green values

    echo "------------------------------------------"
}


#check_running_services
                crs() {
    echo "------------------------------------------"
    echo -e "\033[1;36mRunning Services:\033[0m"  # Cyan title
    echo "------------------------------------------"
    
    # List running services with formatting
    systemctl list-units --type=service --state=running | awk 'NR==1 {print; next} {printf "\033[1;34m%-30s\033[0m %-10s %s\n", $1, $3, $4}'

    echo "------------------------------------------"
}




#dir_size
dis() {
    du -sh ./* 2>/dev/null | sort -rh
}

#clean_memory
cm() {
    echo "Cleaning memory cache..."
    sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
    echo "Memory cache cleaned!"
}
# file fider
ff() {
    local exact_match
    local pattern_match

    # Colors
    local green="\033[1;32m"  # Green for exact matches
    local blue="\033[1;34m"   # Blue for pattern matches
    local reset="\033[0m"     # Reset color

    # First, try an exact match
    exact_match=$(sudo find / -type f -name "$1" 2>/dev/null)

    # If there's an exact match, print it
    if [[ -n "$exact_match" ]]; then
        echo -e "${green}Exact match found:${reset}"
        echo -e "${green}$exact_match${reset}"
    fi

    # Try a fuzzy match with wildcards
    pattern_match=$(sudo find / -type f -iname "*$1*" 2>/dev/null)

    # Print a space before pattern matches if they exist
    if [[ -n "$pattern_match" ]]; then
        echo -e "\n${blue}Pattern matches found (case insensitive):${reset}"
        echo -e "${blue}$pattern_match${reset}"
    fi

    # If neither match is found
    if [[ -z "$exact_match" && -z "$pattern_match" ]]; then
        echo "No files found matching '$1'."
    fi
}


sys_info() {
    whiptail --msgbox "$(uname -a)\n$(free -h)\n$(df -h)" 20 50
}



#PS1='\[\e[38;5;79m\]\u\[\e[0;48;5;127;1m\]\w\[\e[0m\]'
PS1='\[\e[38;5;82m\]\u@\h \[\e[38;5;208m\] \[\e[38;5;75m\]\w \[\e[0;48;5;236;1m\]💻 \[\e[0m\] \$ '
bind -r "\C-z"  # Unbind Ctrl+Z from Bash suspend
eval "$(mcfly init bash)"
source /usr/share/blesh/ble.sh  # For autosuggestions



