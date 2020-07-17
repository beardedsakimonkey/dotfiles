#
# General
#

stty start undef # disable C-s
stty stop undef # disable C-q
stty quit undef # disable C-\

#
# Options
#

setopt AUTO_CD
setopt AUTO_PUSHD
setopt CDABLE_VARS
setopt CD_SILENT 2&>/dev/null # needs zsh 5.8
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

setopt HIST_REDUCE_BLANKS
setopt LIST_PACKED
setopt MENU_COMPLETE

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

unsetopt FLOW_CONTROL
setopt INTERACTIVE_COMMENTS

setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

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

zstyle ':completion:*:*:mpv:*' file-patterns \
    '*.(#i)(flv|mp4|webm|mkv|wmv|mov|avi|mp3|ogg|wma|flac|wav|aiff|m4a|m4b|m4v|gif|ifo)(-.) *(-/):directories' \
    '*:all-files'

zstyle ':completion:*:warnings' format "%F{red}No match for:%f %d"

autoload -Uz compinit && compinit
zmodload -i zsh/complist
compdef _vim v

_comp_options+=(globdots) # complete dotfiles without entering a .

#
# Bindings
# NOTE: `emulate -L zsh` is used to diable some custom setopts
#

function _change-first-word() {
    emulate -L zsh
    zle .beginning-of-line
    zle .kill-word
    zle .vi-insert
}
zle -N _change-first-word

function _man-line() {
    emulate -L zsh
    if [[ -z $BUFFER ]]; then
        return
    fi
    # local buf=$BUFFER
    args=(${(s/ /)BUFFER})
    if [[ $args[1] == 'git' ]] && (( $#args > 1 )); then
        LBUFFER="git help ${args[2]}"
    else
        LBUFFER="man ${args[1]}"
    fi
    zle .accept-line
    # zle -U $buf
}
zle -N _man-line

function _backward-kill-to-slash() {
    emulate -L zsh
    local WORDCHARS="${WORDCHARS:s@/@}"
    zle .backward-kill-word
}
zle -N _backward-kill-to-slash

function _fix-tilde-questionmark() {
    emulate -L zsh
    if [[ $LBUFFER[-1] == \~ ]]; then
        zle -U '/'
    else
        zle .self-insert
    fi
}
zle -N _fix-tilde-questionmark

function _cd_up() {
    emulate -L zsh
    BUFFER="cd .."
    zle .accept-line
}
zle -N _cd_up

function fg-bg() {
    emulate -L zsh
    if [[ $#BUFFER -eq 0 ]]; then
        fg
    else
        zle push-input
    fi
}
zle -N fg-bg

function tab-or-list-dirs() {
    emulate -L zsh
    if [[ $#BUFFER == 0 ]]; then
        # NOTE: leaving `cd` in the prompt is suboptimal because it prevents
        # utilizing suffix aliases. However, deleting it would prevent subsequent
        # tabbing through the list.
        BUFFER="cd "
        CURSOR=3
        zle list-choices
        # select the first result
        zle expand-or-complete
    else
        # do what TAB does by default
        zle expand-or-complete
    fi
}
zle -N tab-or-list-dirs

bindkey "^[j" backward-word
bindkey "^[h" backward-char
bindkey "^[k" forward-word
bindkey "^[l" forward-char

bindkey "\C-a" beginning-of-line
bindkey "\C-e" end-of-line
bindkey "\C-u" backward-kill-line
bindkey "^[." insert-last-word
bindkey -M menuselect "\C-m" .accept-line
bindkey -M menuselect "^[[Z" reverse-menu-complete
bindkey ' ' magic-space # expands history

bindkey -a 'H' vi-beginning-of-line
bindkey -a 'L' vi-end-of-line

bindkey "\C-b" _cd_up
bindkey "\C-h" _man-line
bindkey "\C-w" _backward-kill-to-slash
bindkey "?" _fix-tilde-questionmark
bindkey '^Z' fg-bg
bindkey -a "m" _change-first-word
bindkey '\t' tab-or-list-dirs


#
# Modules
# see: /usr/local/Cellar/zsh/5.8/share/zsh/functions/
#

autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $m $c select-bracketed
    done
done

autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
done

autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround

# NOTE: you have $KEYTIMEOUT ms in between the two keystrokes
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

autoload edit-command-line
zle -N edit-command-line
bindkey "\C-o" edit-command-line; bindkey -a "\C-o" edit-command-line

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

autoload -Uz zcalc

#
# Prompt
#

PROMPT="%F{black}${SSH_TTY:+ssh:}"
PROMPT+="%F{white}%B%50<..<%~%<<"
PROMPT+="%F{green}%(1j. *.)"
PROMPT+=" %(?.%F{yellow}.%F{red})❯%b%f "

# region: vi-mode visual select
zle_highlight=(region:bg=#504945)

#
# Cursor
#

function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]; then
            echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

zle-line-init() { echo -ne '\e[5 q' }
zle -N zle-line-init
zle-line-finish() { echo -ne '\e[1 q' }
zle -N zle-line-finish

#
# Exports
# NOTE: you should put exports that should exist for non-interactive shells in ~/.zshenv
#

export KEYTIMEOUT=15
export CORRECT_IGNORE=_*,.*

export PATH="$HOME/.cargo/bin/:$PATH"
export PATH="$HOME/bin/:$PATH"

export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE=~/.zsh_history

export EDITOR=nvim
export VISUAL=$EDITOR
export PAGER=less
export READNULLCMD=$PAGER

export LESS_TERMCAP_mb=$(printf "\e[01;31m")
export LESS_TERMCAP_md=$(printf "\e[00;33m")
export LESS_TERMCAP_us=$(printf "\e[01;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_ue=$(printf "\e[0m")

#
# Third-party
#

# zsh-autosuggestions
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    bindkey "^ " autosuggest-accept
    bindkey "^@" autosuggest-accept
fi

# fast-syntax-highlighting
if [ -f ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]; then
    source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

# zsh-history-substring-search
if [ -f ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
    bindkey    "\C-p" history-substring-search-up
    bindkey -a "\C-p" history-substring-search-up
    bindkey    "\C-n" history-substring-search-down
    bindkey -a "\C-n" history-substring-search-down
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=#3d4220"
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=#472322"
else
    bindkey "\C-p" up-line-or-search
    bindkey "\C-n" down-line-or-search
fi

# fasd
if [ -n "$(command -v fasd)" ]; then
    eval "$(fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)"
    unalias a z zz
    alias j='fasd_cd -d'
    alias jj='fasd_cd -d -i'
    alias vv='fasd -f -t -e $EDITOR -b viminfo'
    bindkey "^[a" fasd-complete
    bindkey "^[f" fasd-complete-f
    bindkey "^[d" fasd-complete-d
fi

# nvm
if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    export PATH="$NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)/bin:$PATH"
    alias nvm='unalias nvm; . "$NVM_DIR/nvm.sh"; nvm $@'
fi

#
# Aliases
# NOTE: you can escape commands in the alias defintion with `\` to avoid recursive alias expansion
#

alias sudo='\sudo '
alias t='tmux -f ~/.config/tmux/tmux.conf new-session -A -s main'
alias ls='\ls -FG'
alias a='ls -A'
# `compdef` doesn't seem to work on aliases
function v() { $EDITOR "$@" }

alias -s {avi,flv,mkv,mp4,mpeg,mpg,ogv,wmv,flac,mp3,ogg,wav}=mpv
alias -s {avi.part,flv.part,mkv.part,mp4.part,mpeg.part,mpg.part,ogv.part,wmv.part,flac.part,mp3.part,ogg.part,wav.part}=mpv

#
# Functions
#

function mv() {
    emulate -L zsh
    if (( $# > 1 )); then
        local destdir=${_%/*}
        if [ ! -d "$destdir" ]; then
            mkdir -p "$destdir"
        fi
    fi
    command mv "$@"
}

function megadl() {
    emulate -L zsh
    if (( $# < 1 )) || [[ "$1" =~ "mega.nz" ]]; then
        command megadl "$@"
    else
        # FIXME: this assumes a single url argument
        local count=1
        if (( $# > 2 )) && [[ $_ =~ "[:digit:]+" ]]; then
            count="$_"
        fi
        local url="$1"
        for i in {0..count} ; do
            url=$(base64 -d <<<"$url")
        done
        if [[ "$url" =~ "mega.nz" ]];then
            megadl "$url"
        else
            echo "bad url -- $url"
        fi
    fi
}

#
# Source local rc
#

if [ -f ~/zshrc_local.zsh ]; then
    source ~/zshrc_local.zsh
fi
