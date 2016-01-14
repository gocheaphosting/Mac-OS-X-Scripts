# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

# set PATH so it includes MacPorts sbin if it exists
if [ -d "/opt/local/sbin" ] ; then
    PATH="/opt/local/sbin:$PATH"
fi

# set PATH so it includes MacPorts bin if it exists
if [ -d "/opt/local/bin" ] ; then
    PATH="/opt/local/bin:$PATH"
fi

# set PATH so it includes GNU tools from MacPorts if it exists
if [ -d "/opt/local/libexec/gnubin" ] ; then
    PATH="/opt/local/libexec/gnubin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# enable programmable completion features
if [ -f /opt/local/etc/profile.d/bash_completion.sh ] && ! shopt -oq posix; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi

# enable git completion
if [ -f /usr/share/git-core/git-completion.bash ]; then
    . /usr/share/git-core/git-completion.bash
fi
