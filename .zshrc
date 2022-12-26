# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load antigen, download if needed
ANTIGEN_PATH=$HOME/.antigen.zsh
if [ ! -f "$ANTIGEN_PATH" ]; then
  echo "Downloading antigen..."
  curl -L git.io/antigen > $ANTIGEN_PATH
fi
source $ANTIGEN_PATH

# Load the oh-my-zsh library
antigen use oh-my-zsh

# Load some oh-my-zsh plugins
antigen bundle git
antigen bundle sudo
antigen bundle pip
antigen bundle command-not-found
antigen bundle yarn
antigen bundle web-search
antigen bundle copybuffer

# Load plugins from other repos
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle esc/conda-zsh-completion
antigen bundle paulirish/git-open
antigen bundle lukechilds/zsh-nvm
antigen bundle MichaelAquilina/zsh-autoswitch-virtualenv
antigen bundle MichaelAquilina/zsh-you-should-use

# Load the theme
antigen theme romkatv/powerlevel10k

# Save and apply all changes
antigen apply


# Aliases
alias sl='ls'
alias la='ls -A'
alias open='open_command'
alias path='echo "$PATH" | tr ":" "\n" | nl'
alias glg='git log --stat --date=local'
alias ggpush='git push -u origin "$(git_current_branch)"'


if [ -x "$(command -v colorls)" ]; then
  alias lc='colorls'
fi

# Command to logout of KDE desktop
if [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
  alias kdelogout='qdbus org.kde.ksmserver /KSMServer logout 1 3 3'
fi

# Set brightness of external monitor
if [ -x "$(command -v ddcutil)" ]; then
  alias bright="sudo ddcutil setvcp 10"
fi

# Pretty-print json in pager
if [ -x "$(command -v jq)" ]; then
  alias json="jq -C | less -R"
fi

# Auto rehash after pacman package has been installed
TRAPUSR1() { rehash }

# Let yay use multiple cores to compile
export MAKEFLAGS="-j$(nproc)"

# Explanation not really needed
export EDITOR=vim

# Have zsh virtualenv plugin create venvs in project directory
export AUTOSWITCH_VIRTUAL_ENV_DIR="venv"

# Case insensitive searching in less
export LESS="-i -R"

# Ignore alias suggestions for git command
export YSU_IGNORED_ALIASES=("g" "y")

# Syntax highlighting for man
if [ -x "$(command -v batcat)" ]; then
  export BAT_THEME=Coldark-Dark
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
  alias bat='batcat'
elif [ -x "$(command -v bat)" ]; then
  export BAT_THEME=Coldark-Dark
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# If in WSL, export environment variables for X forwarding,
# given that WSLg is not enabled on Windows 11
if [[ -v WSL_DISTRO_NAME ]] && [[ ! -v DISPLAY ]]; then
  export DISPLAY=$(ip route list default | awk '{print $3}'):0
  export LIBGL_ALWAYS_INDIRECT=1
  
  # 2x scaling for hidpi displays
  export GDK_SCALE=2
fi

# Check if in WSL
if [[ -v WSL_DISTRO_NAME ]]; then
  # Add option to remove Windows directories from PATH if file system is getting too slow
  rm_mnt () { PATH=$(echo $PATH | sed s/:/\\n/g | grep -v '/mnt/c' | sed ':a;N;$!ba;s/\n/:/g'); }
fi

# Check if current terminal is capable of using nerd fonts,
# then load p10k config and set some aliases & vars accordingly
if [[ -v WT_SESSION ]]; then
  terminal_emulator="wt"
else
  terminal_emulator=$(ps -p $(ps -p $$ -o ppid=) -o args=);
fi
case $terminal_emulator in
    *konsole* | wt)
    	if [ -x "$(command -v lsd)" ]; then
  	  alias ls='lsd'
        fi
        export SUDO_PROMPT=$'[sudo] password for %p \033[01;33m\Uf80a\033[00m: '
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        ;;
    *)
        if [ -x "$(command -v lsd)" ]; then
          alias ls='lsd --icon=never'
        fi
        [[ ! -f ~/.p10k.alt.zsh ]] || source ~/.p10k.alt.zsh
        ;;
esac
