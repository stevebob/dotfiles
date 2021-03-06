export PATH="$HOME/bin:$HOME/.bin:$HOME/.local/bin:$HOME/.local/sbin:/usr/games:/usr/local/games:$PATH"

# Source extra commands from .profile_extra
[ -f ~/.profile_extra ] && . ~/.profile_extra

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Set some rust-specific environment variables if rust is installed
if type rustc 2>/dev/null >/dev/null && [ -d ~/.cargo ]; then
    export RUST_SRC_PATH=$(rustc --print sysroot)"/lib/rustlib/src/rust/src"
    export CARGO_HOME=$HOME/.cargo
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
[ -d "$HOME/.rvm/bin" ] && export PATH="$PATH:$HOME/.rvm/bin"

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . ~/.bashrc
    fi
fi

# Start nix environment if present
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
  . ~/.nix-profile/etc/profile.d/nix.sh
  export LOCALE_ARCHIVE="$(readlink ~/.nix-profile/lib/locale)/locale-archive"
fi

# Use neovim, vim, or vi as editor
if type nvim 2>/dev/null >/dev/null; then
    export EDITOR=nvim
    export VISUAL=nvim
elif type vim 2>/dev/null >/dev/null; then
    export EDITOR=vim
    export VISUAL=vim
else
    export EDITOR=vi
    export VISUAL=vi
fi
