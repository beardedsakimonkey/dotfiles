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
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''

autoload -Uz compinit && compinit
zmodload -i zsh/complist

#
# Bindings
#

_change-first-word() {
  zle beginning-of-line
  zle kill-word
}
zle -N _change-first-word

_man-line() {
  first_arg=$(echo $LBUFFER | cut -d ' ' -f1)
  LBUFFER="man $first_arg"
  zle accept-line
}
zle -N _man-line

_backward-kill-to-slash() {
  local WORDCHARS="${WORDCHARS:s@/@}"
  zle backward-kill-word
}
zle -N _backward-kill-to-slash

_fix-tilde-questionmark() {
  if [[ $LBUFFER[-1] == \~ ]]; then
    zle -U '/'
  else
    zle self-insert
  fi
}
zle -N _fix-tilde-questionmark

bindkey "∆"   backward-word; bindkey "\Mj" backward-word
bindkey "˙"   backward-char; bindkey "\Mh" backward-char
bindkey "˚"   forward-word;  bindkey "\Mk" forward-word
bindkey "¬"   forward-char;  bindkey "\Ml" forward-char

bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^U" backward-kill-line
bindkey "\M." insert-last-word; bindkey "≥" insert-last-word
bindkey -M menuselect '^M' .accept-line
bindkey -M menuselect "^[[Z" reverse-menu-complete
bindkey ' ' magic-space # expands history

bindkey -a 'H' vi-beginning-of-line
bindkey -a 'L' vi-end-of-line

bindkey -s '\eu' '^Ucd ..^M'
bindkey "\Mm" _man-line; bindkey "µ" _man-line
bindkey "\?" _fix-tilde-questionmark
bindkey "\Ma" _change-first-word; bindkey "å" _change-first-word
bindkey "^W" _backward-kill-to-slash

#
# Modules
#

autoload edit-command-line
zle -N edit-command-line
bindkey "\Me" edit-command-line; bindkey "´" edit-command-line

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':chpwd:*' recent-dirs-default true

#
# VCS
#

autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
precmd() {
  vcs_info
}

#
# Prompt
#

PROMPT="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}"
PROMPT+="%F{white}%B%50<..<%~%<<"
PROMPT+="%F{green}%(1j. *.)"
PROMPT+=" %(?.%F{yellow}.%F{red})❯%b%f "
RPROMPT="\${vcs_info_msg_0_}"

SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

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
  bindkey '^ ' autosuggest-accept
fi

export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)/bin:$PATH"
alias nvm='unalias nvm; . "$NVM_DIR/nvm.sh"; nvm $@'
