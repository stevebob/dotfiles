#!/usr/bin/env bash
set -euxo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TARGET=$HOME

function make_link {
    DEST="$TARGET/$2"
    if test -e "$DEST"; then
        echo "$DEST already exists"
    else
        mkdir -p "$(dirname "$DEST")"
        ln -s "$DIR/$1" "$DEST"
    fi
}

cd "$HOME"

make_link nvim .vim
make_link nvim .config/nvim
make_link nvim/init.vim .vimrc

if [ ! -e "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi

# link archlinux-specific packages
if type pacman 2>/dev/null >/dev/null; then
    make_link dwm pkg/dwm
    make_link st pkg/st
fi

make_link bashrc .bashrc
make_link bash_profile .bash_profile
make_link inputrc .inputrc
make_link xinitrc .xinitrc
make_link tmux.conf .tmux.conf
make_link htoprc .config/htop/htoprc
make_link bin .bin

echo Done!
