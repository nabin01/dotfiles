#!/bin/sh

# Use neovim for vim if present
command -v nvim > /dev/null && alias vim="nvim" vimdiff="nvim -d"

# general and verbose
alias \
	cp="cp -iv" \
	mv="mv -iv" \
	rm="rm -iv" \
    mkd="mkdir -pv"

# colorize commands when possible
alias \
	l="ls -hN --color=auto --group-directories-first" \
	ls="ls -hN --color=auto --group-directories-first" \
	la="ls -a" \
	ll="ls -l" \
	grep="grep --color=auto" \
	diff="diff --color=auto" \
	ccat="highlight --out-format=ansi"

alias \
    g="git" \
    p="sudo pacman" \
    f="$FILE" \
    e="$EDITOR" \
    v="$EDITOR"

alias \
    powerup="sudo pacman -Syu --noconfirm && yay -Syu --noconfirm" \
    testwh="sudo create_ap wlp2s0 wlp2s0 test test123123" \
    uvm="ssh -p 2222 nabin@127.0.0.1" \
    virtualenv="virtualenv --system-site-packages -p python3.7"
    
# directories
alias \
    de="cd ~/Desktop" \
    d="cd ~/Documents" \
    D="cd ~/Downloads"

# edit files
alias \
    i="$EDITOR ~/.i3/config" \
    v="$EDITOR ~/.config/nvim/init.vim" \
    n="cd ~/Documents/n && $EDITOR note" \
    c="cd ~/Documents/78/note && $EDITOR note" 
