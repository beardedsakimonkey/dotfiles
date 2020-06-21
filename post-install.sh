#!/bin/bash

set -e

git submodule update --init --remote
tic ~/tmux-256color.terminfo
fast-theme ~/.zsh/overlay.ini
( cd ~/.zsh/fasd && make install )
