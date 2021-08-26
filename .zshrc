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

# Syntax highlighting for man
if [ -x "$(command -v batcat)" ]; then
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
elif [ -x "$(command -v bat)" ]; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Load p10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
