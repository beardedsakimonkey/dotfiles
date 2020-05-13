#
# Options
#

setopt auto_cd
setopt auto_pushd
setopt cdable_vars
setopt pushd_ignore_dups
setopt pushd_silent

setopt hist_reduce_blanks
setopt list_packed
setopt menu_complete

setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt inc_append_history

setopt correct
setopt NO_flow_control
setopt interactive_comments

setopt prompt_subst
setopt transient_rprompt

#
# Completion
#

zstyle ':completion:*' menu select=2
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=* l:|=*'
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

zstyle ':completion:*:default' list-colors no=00 fi=00 di=00\;34 pi=33 so=01\;35 bd=00\;35 cd=00\;34 or=00\;41 mi=00\;45 ex=01\;32
zstyle ':completion:*:options' list-colors '=^(-- *)=0;36'
zstyle ':completion:*:builtins' list-colors '=*=0;32'

zstyle ':completion:*:warnings' format "%F{1}No match for:%f %d"

autoload -Uz compinit && compinit
zmodload -i zsh/complist

#
# Bindings
#

_change-first-word() {
  zle .beginning-of-line
  zle .kill-word
}
zle -N _change-first-word

_man-line() {
  if [[ -z $BUFFER ]]; then
    return
  fi
  local buf=$BUFFER
  args=(${(s/ /)BUFFER})
  if [[ $args[1] == 'git' ]] && (( $#args > 1 )); then
    LBUFFER="git help ${args[2]}"
  else
    LBUFFER="man ${args[1]}"
  fi
  zle .accept-line
  zle -U $buf
}
zle -N _man-line

_backward-kill-to-slash() {
  local WORDCHARS="${WORDCHARS:s@/@}"
  zle .backward-kill-word
}
zle -N _backward-kill-to-slash

_fix-tilde-questionmark() {
  if [[ $LBUFFER[-1] == \~ ]]; then
    zle -U '/'
  else
    zle .self-insert
  fi
}
zle -N _fix-tilde-questionmark

_cd_up() {
  local buf=$BUFFER
  BUFFER="cd .."
  zle .accept-line
  zle -U ${buf:-''}
}
zle -N _cd_up

# _tab() {
#   if [[ -z $BUFFER ]]; then
#     zle -U './'
#     zle .list-choices
#   else
#     zle .complete-word
#   fi
# }
# zle -N _tab

bindkey "∆" backward-word; bindkey "\M-j" backward-word
bindkey "˙" backward-char; bindkey "\M-h" backward-char
bindkey "˚" forward-word;  bindkey "\M-k" forward-word
bindkey "¬" forward-char;  bindkey "\M-l" forward-char

bindkey "\C-p" up-line-or-search
bindkey "\C-n" down-line-or-search
bindkey "\C-a" beginning-of-line
bindkey "\C-e" end-of-line
bindkey "\C-u" backward-kill-line
bindkey "\M-." insert-last-word; bindkey "≥" insert-last-word
bindkey -M menuselect "\C-m" .accept-line
bindkey -M menuselect "^[[Z" reverse-menu-complete
bindkey ' ' magic-space # expands history

bindkey -a 'H' vi-beginning-of-line
bindkey -a 'L' vi-end-of-line

bindkey "\C-b" _cd_up
bindkey "\C-h" _man-line
bindkey "\C-x" _change-first-word
bindkey "\C-w" _backward-kill-to-slash
bindkey "?" _fix-tilde-questionmark
# bindkey "\t" _tab

#
# Modules
#

autoload edit-command-line
zle -N edit-command-line
bindkey "\C-o" edit-command-line

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':chpwd:*' recent-dirs-default true

#
# VCS
#

# autoload -Uz vcs_info
# zstyle ':vcs_info:*' actionformats '%F{magenta}[%F{green}%b%F{yellow}|%F{red}%a%F{magenta}]%f '
# zstyle ':vcs_info:*' formats '%F{magenta}[%F{green}%b%F{magenta}]%f '
# zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{red}:%F{yellow}%r'
# precmd() {
#   vcs_info
# }
# RPROMPT="\${vcs_info_msg_0_}"

#
# Prompt
#

PROMPT="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}"
PROMPT+="%F{white}%B%50<..<%~%<<"
PROMPT+="%F{green}%(1j. *.)"
PROMPT+=" %(?.%F{yellow}.%F{red})❯%b%f "

SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

zle_highlight=(region:bg=#504945)

#
# Cursor
#

# # Remove mode switching delay.
# KEYTIMEOUT=1

# function zle-keymap-select {
#   if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
#     echo -ne '\e[1 q'
#   elif [[ ${KEYMAP} == main ]] ||
#     [[ ${KEYMAP} == viins ]] ||
#     [[ ${KEYMAP} = '' ]] ||
#     [[ $1 = 'beam' ]]; then
#       echo -ne '\e[5 q'
#   fi
# }
# zle -N zle-keymap-select

# zle-line-init() { echo -ne '\e[5 q' }
# zle -N zle-line-init
# zle-line-finish() { echo -ne '\e[1 q' }
# zle -N zle-line-finish

#
# Aliases
#

alias sudo='sudo '
alias t='tmux attach || tmux new'
alias ls='ls -F -G'
alias ll='ls -ahlF'
alias la='ls -FA'
alias a='la'
alias v='$EDITOR'

#
# Exports
#

export PATH="$HOME/.cargo/bin/:$PATH"
export PATH="$HOME/bin/:$PATH"

export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE=~/.zsh_history

export VISUAL=nvim
export EDITOR=nvim
export PAGER=less
export READNULLCMD=less

export LESS_TERMCAP_mb=$(printf "\e[01;31m")
export LESS_TERMCAP_md=$(printf "\e[00;33m")
export LESS_TERMCAP_us=$(printf "\e[01;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_ue=$(printf "\e[0m")

#
# Third-party
#

if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  bindkey "^ " autosuggest-accept
  bindkey "^@" autosuggest-accept
fi

if [ -f ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]; then
  source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

export FZF_DEFAULT_COMMAND='rg -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export PATH="$HOME/.fzf/bin/:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)/bin:$PATH"
alias nvm='unalias nvm; . "$NVM_DIR/nvm.sh"; nvm $@'

if [ -f ~/zshrc_local.zsh ]; then
  source ~/zshrc_local.zsh
fi
