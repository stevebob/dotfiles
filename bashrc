#!/usr/bin/env bash

# Only run if the shell is interactive
if [[ $- == *i* ]]; then

    # Use neovim, vim, or vi as editor
    if type nvim 2>/dev/null >/dev/null; then
        alias vim=nvim
    elif ! type vim 2>/dev/null >/dev/null; then
        alias vim=vi
    fi

    # Tmux unicode and 256 colour support
    alias tmux='tmux -u -2'

    # Allow aliases in sudo
    alias sudo='sudo '

    # Some handy aliases
    alias tmp='pushd $(mktemp -d)'
    alias rebash='source $HOME/.bashrc'
    alias AOEU='aoeu'
    alias ASDF='asdf'
    alias nix-shell='nix-shell --command "$(declare -p PS1); return"'

    # Archlinux-specific pacman helpers
    if type pacman 2>/dev/null >/dev/null; then
        alias explicit-non-default-packages='comm -23 <(pacman -Qqe | sort) <(pacman -Qqg base base-devel | sort)'
        alias orphaned-packages='pacman -Qdtq'
    fi

    # Set colours for `ls` to use. If gnu-ls is installed, prefer it over ls.
    export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=1;30;42:ow=1;30;43'
    if type gls 2>/dev/null >/dev/null; then
        alias ls='gls --color --human-readable --group-directories-first'
    elif type colorls 2>/dev/null >/dev/null; then
        alias ls='colorls -G'
    elif ls --color --group-directories-first 2>/dev/null >/dev/null; then
        alias ls='ls --color -h --group-directories-first'
    elif ls --color 2>/dev/null >/dev/null; then
        # freebsd appears to understand --color, but not --group-directories-first
        alias ls='ls --color -h'
    else
        # this case will be hit on macos and bsd without gls installed
        alias ls='ls -h'
    fi

    # Customize bash history behaviour
    export HISTCONTROL=ignoredups:erasedups
    export HISTSIZE=100000
    export HISTFILESIZE=100000
    shopt -s histappend

    # Start keychain if it is installed
    if type keychain 2>/dev/null >/dev/null && [[ $(basename "$SHELL") == "bash" ]] && [[ -e ~/.ssh/id_rsa ]]; then
       eval $(keychain --quiet --agents ssh id_rsa --eval)
    fi

    # opam configuration
    test -r ~/.opam/opam-init/init.sh && . ~/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

    # FZF
    [[ -f ~/.fzf.bash ]] && [[ "$SHELL" == "/bin/bash" ]] && source ~/.fzf.bash

    # Lazily load NVM
    nvm() {
        if [[ -d ~/.nvm ]]; then
            if type realpath 2>/dev/null >/dev/null; then
                export NVM_DIR=$(realpath "$HOME/.nvm")
            else
                export NVM_DIR="$HOME/.nvm"
            fi
            [[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
            [[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
            nvm $@
        else
            echo nvm is not installed
            echo install with:
            echo "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash"
        fi
    }

    man() {
        LESS_TERMCAP_md=$'\e[01;31m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[01;44;33m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[01;32m' \
        command man "$@"
    }

    # Git Prompt
    [[ -f ~/.git-prompt.sh ]] && source ~/.git-prompt.sh

    __prompt_command() {
        local EXIT="$?";

        if [[ $(id -u) == '0' ]]; then
            local TERMINATOR="#"
        else
            local TERMINATOR="$"
        fi

        if type __git_ps1 2>/dev/null >/dev/null; then
            local GIT_MESSAGE="$(GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWUPSTREAM=auto __git_ps1) "
        else
            local GIT_MESSAGE=" "
        fi

        if [[ $EXIT != 0 ]]; then
            local EXIT_CODE_MESSAGE="\[\033[01;31m\]$EXIT\[\033[01;39m\] "
        else
            local EXIT_CODE_MESSAGE=""
        fi

        PS1="\[\033[01;1m\]\u@\h \w$GIT_MESSAGE$EXIT_CODE_MESSAGE$TERMINATOR\[\033[01;0m\] "
    }

    PROMPT_COMMAND=__prompt_command

    # source extra commands from .bashrc_extra
    [[ -f ~/.bashrc_extra ]] && source ~/.bashrc_extra

    true
fi
