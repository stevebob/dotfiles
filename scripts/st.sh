#!/bin/bash
set -euxo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG=$DIR/../st/config.h

NAME=st
VERSION=0.8.2
SRC_FILENAME="st-$VERSION.tar.gz"
SRC_DIR="st-$VERSION"
SRC_URL="https://dl.suckless.org/st/$SRC_FILENAME"
SRC_CHECKSUM="aeb74e10aa11ed364e1bcc635a81a523119093e63befd2f231f8b0705b15bf35"
BOLD_IS_NOT_BRIGHT_FILENAME="bold-is-not-bright.diff"
BOLD_IS_NOT_BRIGHT_URL="https://st.suckless.org/patches/bold-is-not-bright/st-bold-is-not-bright-20190127-3be4cf1.diff"
BOLD_IS_NOT_BRIGHT_CHECKSUM="329169acac7ceaf901995d6e0897913089b799d8cd150c7f04c902f4a5b8eab2"
SCROLLBACK_FILENAME="scrollback.diff"
SCROLLBACK_URL="https://st.suckless.org/patches/scrollback/st-scrollback-$VERSION.diff"
SCROLLBACK_CHECKSUM="9c5aedce2ff191437bdb78aa70894c3c91a47e1be48465286f42d046677fd166"
SCROLLBACK_MOUSE_FILENAME="scrollback-mouse.diff"
SCROLLBACK_MOUSE_URL="https://st.suckless.org/patches/scrollback/st-scrollback-mouse-$VERSION.diff"
SCROLLBACK_MOUSE_CHECKSUM="6103a650f62b5d07672eee9e01e3f4062525083da6ba063e139ca7d9fd58a1ba"
SCROLLBACK_MOUSE_ALTSCREEN_FILENAME="scrollback-mouse-altscreen.diff"
SCROLLBACK_MOUSE_ALTSCREEN_URL="https://st.suckless.org/patches/scrollback/st-scrollback-mouse-altscreen-0.8.diff"
SCROLLBACK_MOUSE_ALTSCREEN_CHECKSUM="bcfc106089d9eb75aa014d4915ed3e6842f1df54edd8b75597154096333df6fa"

BUILD_DIR=$1

mkdir -p $BUILD_DIR

echo "Working in $BUILD_DIR"
pushd $BUILD_DIR

wget $SRC_URL -O $SRC_FILENAME
echo "$SRC_CHECKSUM $SRC_FILENAME" | sha256sum -c || exit 1

wget $BOLD_IS_NOT_BRIGHT_URL -O $BOLD_IS_NOT_BRIGHT_FILENAME
echo "$BOLD_IS_NOT_BRIGHT_CHECKSUM $BOLD_IS_NOT_BRIGHT_FILENAME" | sha256sum -c || exit 1

wget $SCROLLBACK_URL -O $SCROLLBACK_FILENAME
echo "$SCROLLBACK_CHECKSUM $SCROLLBACK_FILENAME" | sha256sum -c || exit 1

wget $SCROLLBACK_MOUSE_URL -O $SCROLLBACK_MOUSE_FILENAME
echo "$SCROLLBACK_MOUSE_CHECKSUM $SCROLLBACK_MOUSE_FILENAME" | sha256sum -c || exit 1

wget $SCROLLBACK_MOUSE_ALTSCREEN_URL -O $SCROLLBACK_MOUSE_ALTSCREEN_FILENAME
echo "$SCROLLBACK_MOUSE_ALTSCREEN_CHECKSUM $SCROLLBACK_MOUSE_ALTSCREEN_FILENAME" | sha256sum -c || exit 1

tar xvzf $SRC_FILENAME
patch -d $SRC_DIR -p1 < $BOLD_IS_NOT_BRIGHT_FILENAME
patch -d $SRC_DIR -p1 < $SCROLLBACK_FILENAME
patch -d $SRC_DIR -p1 < $SCROLLBACK_MOUSE_FILENAME
patch -d $SRC_DIR -p1 < $SCROLLBACK_MOUSE_ALTSCREEN_FILENAME
ln -sf $CONFIG $(pwd)/$SRC_DIR
