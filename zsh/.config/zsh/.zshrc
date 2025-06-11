autoload -Uz compinit
compinit
autoload -Uz colors; colors

[ -f "${ZDOTDIR}/aliasrc" ] &&source "${ZDOTDIR}/aliasrc"

setopt autocd

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33
zstyle ':completion:*' squeeze-slashes false
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''

bindkey -v
export KEYTIMEOUT=1

source <(fzf --zsh)

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.cache/.zhistory"

source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#autoload -Uz vcs_info
#zstyle ':vcs_info:*' enable git
#zstyle ':vcs_info:*' check-for-changes true
#zstyle ':vcs_info:*' stagedstr   '+ '        # index     changes
#zstyle ':vcs_info:*' unstagedstr '* '        # work-tree changes
#zstyle ':vcs_info:git:*' formats 'git:(%b) %c%u'  # → “main ✚●”

#precmd() { 
#    vcs_info 
#    # Default: not in a repo
#    GIT_COLOR='%f'                 # reset / no colour
#
#    if [[ -n ${vcs_info_msg_0_} ]]; then
#        case ${vcs_info_msg_0_} in
#            (*\**)          GIT_COLOR='%F{red}'    ;;  # unstaged present → red
#            (*+*)           GIT_COLOR='%F{yellow}' ;;  # staged only      → yellow
#            (*)             GIT_COLOR='%F{green}'  ;;  # clean            → green
#        esac
#    fi
#}
#precmd() {
#    local raw git_color git_symbol
#    vcs_info                                  # refresh ${vcs_info_msg_0_}
#  raw=${vcs_info_msg_0_}
#
#  # -------- map state → colour + symbol ------------------------------------
#  if [[ -z $raw ]]; then
#    git_color='%f'                          # not in a repo
#  elif [[ $raw == *+* && $raw == *\** ]]; then
#    git_color='%F{magenta}'   # both staged & unstaged
#    # strip +* and add a single ±
#    raw=${raw//[+*]/}
#    raw=${${raw%% }%% }      # trim trailing spaces
#    raw+="± "
#  elif [[ $raw == *+* ]]; then
#    git_color='%F{yellow}'    # staged only
#  elif [[ $raw == *\** ]]; then
#    git_color='%F{red}'       # unstaged only
#  else
#    git_color='%F{green}'     # clean
#  fi
#
#  GIT_PROMPT="${git_color}${raw}%f"
#}
#
#setopt PROMPT_SUBST
#PROMPT='%F{cyan}➜%f %B%F{blue}%1~%f %B${GIT_PROMPT}%f%b'


# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#636da6"

# fnm
FNM_PATH="/home/gabriel/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/gabriel/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# zoxide
eval "$(zoxide init zsh)"

# starship
eval "$(starship init zsh)"
