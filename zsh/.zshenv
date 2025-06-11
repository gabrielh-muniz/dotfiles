if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

export EDITOR="nvim" 
export TERMINAL="ghostty"

export ZDOTDIR=$HOME/.config/zsh

export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
