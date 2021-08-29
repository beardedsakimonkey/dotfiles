#
# General
# functions: /usr/local/opt/zsh/share/zsh/functions/
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

setopt LIST_PACKED
setopt MENU_COMPLETE

setopt HIST_REDUCE_BLANKS
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

fpath=( $HOME/.zsh/completions $fpath )

autoload -Uz compinit && compinit
zmodload -i zsh/complist

_comp_options+=(globdots) # complete dotfiles without entering a .

#
# Bindings
# NOTE: `emulate -L zsh` is used to diable some custom setopts
#

bindkey "\C-a" beginning-of-line
bindkey "\C-e" end-of-line
bindkey "\C-u" backward-kill-line
bindkey -M menuselect "\C-m" .accept-line
bindkey -M menuselect "^[[Z" reverse-menu-complete
bindkey ' ' magic-space # expands history

bindkey -a 'H' vi-beginning-of-line
bindkey -a 'L' vi-end-of-line

bindkey "\C-b" __cd_up
__cd_up() {
    emulate -L zsh
    BUFFER="cd .."
    zle .accept-line
}
zle -N __cd_up

bindkey "\C-h" __man_line
__man_line() {
    emulate -L zsh
    if [[ -z $BUFFER ]]; then
        return
    fi
    args=(${(s/ /)BUFFER})
    if [[ $args[1] == 'git' ]] && (( $#args > 1 )); then
        LBUFFER="git help ${args[2]}"
    else
        LBUFFER="man ${args[1]}"
    fi
    zle .accept-line
}
zle -N __man_line

bindkey "\C-w" __backward_kill_to_slash
__backward_kill_to_slash() {
    emulate -L zsh
    local WORDCHARS="${WORDCHARS:s@/@}"
    zle .backward-kill-word
}
zle -N __backward_kill_to_slash


bindkey "?" __fix_tilde_questionmark
__fix_tilde_questionmark() {
    emulate -L zsh
    if [[ $LBUFFER[-1] == \~ ]]; then
        zle -U '/'
    else
        zle .self-insert
    fi
}
zle -N __fix_tilde_questionmark


bindkey '^Z' __fg_bg
__fg_bg() {
    emulate -L zsh
    if [[ $#BUFFER -eq 0 ]]; then
        fg
    else
        zle push-input
    fi
}
zle -N __fg_bg

bindkey '\t' __tab_or_list_dirs
__tab_or_list_dirs() {
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
zle -N __tab_or_list_dirs

bindkey -a "m" __change_first_word
__change_first_word() {
    emulate -L zsh
    zle .beginning-of-line
    zle .kill-word
    zle .vi-insert
}
zle -N __change_first_word

# FIXME: zsh-autosuggestions messes this up
bindkey -a ";" __insert_last_word
__insert_last_word() {
    zle .vi-add-next
    zle .insert-last-word
}
zle -N __insert_last_word


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
PROMPT+="%F{black}%B%50<..<%~%<<"
PROMPT+="%F{green}%(1j. *.)"
PROMPT+=" %(?.%F{white}.%F{red})❯%b%f "

# region: vi-mode visual select
zle_highlight=(region:bg=#504945)

#
# Cursor
#

# zle-keymap-select() {
#     if [[ ${KEYMAP} == vicmd ]]; then
#         echo -ne '\e[5 q' # beam
#     elif [[ ${KEYMAP} == main ]] ||
#         [[ ${KEYMAP} == viins ]] ||
#         [[ ${KEYMAP} = '' ]]; then
#             echo -ne '\e[1 q' # block
#     fi
# }
# zle -N zle-keymap-select

# zle-line-init() { echo -ne "\e[1q" }
# zle -N zle-line-init
# zle-line-finish() { echo -ne "\e[1q" }
# zle -N zle-line-finish

#
# Exports
# NOTE: you should put exports that should exist for non-interactive shells in ~/.zshenv
#

export HISTSIZE=999999999
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zsh_history

export KEYTIMEOUT=15
export CORRECT_IGNORE=_*,.*

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
    # HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=#3d4220"
    # HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=#472322"

    # light
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=#afffaf"
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=#ffd7ff"
else
    bindkey "\C-p" up-line-or-search
    bindkey "\C-n" down-line-or-search
fi

# fasd
if [ -n "$(command -v fasd)" ]; then
    eval "$(fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)"
    unalias a s sd sf d f z zz
    alias d='fasd_cd -d'
    alias vf='fasd_cdv -f -B shada'
    alias vd='fasd_cdv -d -B shada'
    alias va='fasd_cdv -a -B shada'

    fasd_cdv() {
        if (( $# < 1 )); then
            fasd "$@"
        else
            local _fasd_ret="$(fasd -e 'printf %s' "$@")"
            [ -z "$_fasd_ret" ] && return
            if [ -d "$_fasd_ret" ]; then
                builtin cd "$_fasd_ret"
                $EDITOR
            elif [ -e "$_fasd_ret" ]; then
                builtin cd $(dirname "$_fasd_ret")
                $EDITOR $(basename "$_fasd_ret")
            fi
        fi
    }
    compctl -U -K _fasd_zsh_cmd_complete -V fasd -x 'C[-1,-*e],s[-]n[1,e]' -c - 'c[-1,-A][-1,-D]' -f -- fasd_cdv
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
alias gj='git-jump'
alias gs='git status'
alias gl='git log'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gp='git push'

makenvim() {
    pushd ~/code/neovim
    rm -r build/  # clear the CMake cache
    make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/local/nvim" CMAKE_BUILD_TYPE=RelWithDebInfo
    make CMAKE_INSTALL_PREFIX=$HOME/local/nvim install
    popd
    tput bel
}

# `compdef` doesn't seem to work on aliases
v() { $EDITOR "$@" }
compdef _vim v

# alias -s {avi,flv,mkv,mp4,mpeg,mpg,ogv,wmv,flac,mp3,ogg,wav}=mpv
# alias -s {avi.part,flv.part,mkv.part,mp4.part,mpeg.part,mpg.part,ogv.part,wmv.part,flac.part,mp3.part,ogg.part,wav.part}=mpv

#
# Functions
#

mv() {
    emulate -L zsh
    if (( $# > 1 )) && [[ "${@[-1]}" =~ / ]]; then
        local destdir=${@[-1]%/*}
        if [ ! -d "$destdir" ]; then
            printf 'making intermediate directories: %s\n' "$destdir"
            mkdir -p "$destdir"
        fi
    fi
    command mv "$@"
}

cd() {
    emulate -L zsh
    if (( $# > 0 )) && [[ ! -d "$1" && -e "$1" ]]; then
        printf 'no such directory: %s\n' "$1"
        builtin cd $(dirname $1)
    else
        builtin cd "$@"
    fi
}

megadl() {
    emulate -L zsh
    if (( $# < 1 )) || [[ "$1" =~ "mega.nz" ]]; then
        command megadl "$@"
    else
        # TODO: just loop, don't pass a count
        local count=1
        if (( $# > 1 )) && [[ ${@[-1]} =~ [0-9] ]]; then
            count="${@[-1]}"
        fi
        local url="$1"
        for i in {1..$count}; do
            url=$(base64 -d <<<"$url")
        done
        if [[ "$url" =~ "mega.nz" ]];then
            megadl "$url"
        else
            printf "bad url: %s\n" "$url"
        fi
    fi
}

subup() {
    git submodule foreach "
    git fetch;
    git log --date=relative --graph --format=\"%C(blue)%h %C(yellow)%>(12)%ad %Cgreen%<(7)%aN%C(auto)%d %Creset%s\" HEAD..origin/HEAD;
    if [[ \$(git rev-parse HEAD) != \$(git rev-parse origin/HEAD) ]]; then
        read -n 1 -p 'checkout origin/HEAD? [yn] ' key;
        printf '\\n';
        if [[ \$key = 'y' ]]; then
            git checkout origin/HEAD;
        fi
    fi
    true
"
}

#
# Source local rc
#

if [ -f ~/zshrc_local.zsh ]; then
    source ~/zshrc_local.zsh
fi
