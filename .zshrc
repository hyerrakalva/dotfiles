# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load antigen
source $HOME/.antigen.zsh

# Load the oh-my-zsh library
antigen use oh-my-zsh

# Load some oh-my-zsh plugins
antigen bundle git
antigen bundle sudo
antigen bundle pip
antigen bundle command-not-found
antigen bundle yarn

# Load plugins from other repos
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle esc/conda-zsh-completion

# Load the theme
antigen theme romkatv/powerlevel10k

# Save and apply all changes
antigen apply


# Aliases
alias sl='ls'
alias la='ls -A'

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


# Auto rehash after pacman package has been installed
TRAPUSR1() { rehash }

# Let yay use multiple cores to compile
export MAKEFLAGS="-j$(nproc)"

# Explanation not really needed
export EDITOR=vim

# Syntax highlighting for man
if [ -x "$(command -v batcat)" ]; then
  export BAT_THEME=Coldark-Dark
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
elif [ -x "$(command -v bat)" ]; then
  export BAT_THEME=Coldark-Dark
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# If in WSL, export environment variables for X forwarding
if [[ -v WSL_DISTRO_NAME ]]; then
  export DISPLAY=$(ip route list default | awk '{print $3}'):0
  export LIBGL_ALWAYS_INDIRECT=1
  
  # 2x scaling for hidpi displays
  export GDK_SCALE=2
fi

# Load p10k config, fallback to basic font in non-primary terminal
if [[ -v WT_SESSION ]]; then
  terminal_emulator="wt"
else
  terminal_emulator=$(ps -p $(ps -p $$ -o ppid=) -o args=);
fi
case $terminal_emulator in
    *konsole* | wt)
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        ;;
    *)
        [[ ! -f ~/.p10k.alt.zsh ]] || source ~/.p10k.alt.zsh
        ;;
esac

# Load nvm
if [ -s /usr/share/nvm/init-nvm.sh ]; then
  # If nvm was installed via AUR
  source /usr/share/nvm/init-nvm.sh
else
  # If nvm was installed via script
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi
