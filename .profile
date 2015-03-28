# ~/.Profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# used as a mostly static variable declaration file.
# note that this is why this file is sourced even from things
#  that normally don't source this, e.g. bash if .bash_profile
#  exists.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# general environment variables
export PATH="~/bin:$PATH"
if [ -n "$DISPLAY" ]; then
	export BROWSER=firefox
else
	export BROWSER=lynx
fi

# TODO: this may not be safe if there's no controlling TTY, but it should be
# if GNOME Keyring is available, use it in TTYs as well as graphical environments
#if [ -x /usr/bin/gnome-keyring-daemon ] && [ -n SSH_AUTH_SOCK ] && [ -n GPG_AGENT_INFO ] && [ -n DISPLAY ]; then
#	# note: we don't set this if $DISPLAY is set because then we override GNOME Shell's auth dialogs with our own
#	# the call to this binary is expensive so we cache the result
#	_GNOME_KEYRING_INFO=$(gnome-keyring-daemon -s)
#	export $(echo $_GNOME_KEYRING_INFO | grep SSH_AUTH_SOCK)
#	export $(echo $_GNOME_KEYRING_INFO | grep GPG_AGENT_INFO)
#fi

if type ruby &> /dev/null; then
	# Fix Bundler behavior on Arch
	export GEM_HOME=$(ruby -e 'print Gem.user_dir')
	# Add local Gems to PATH
	PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
fi

# add the sbins to the path on Debian, because it bugs me that they aren't there by default
if [ -f /etc/os-release ]; then
	# could probably be done better, e.g. using a function or bash -c.
	# as it stands, this pollutes the global scope. I don't really care though, so I probably won't fix it.
	source /etc/os-release
	if [ "$NAME" = "Debian GNU/Linux" ]; then export PATH=/sbin:/usr/sbin:$PATH; fi
fi

if [ $(uname -s) = "Darwin" ]; then
	# For distributed.net client
	PATH="$PATH:/Applications/dnetc518-macosx-x86"
	# For MacPorts
	PATH="$PATH:/opt/local/bin:/opt/local/sbin"
	# For Fink
	test -r /sw/bin/init.sh && . /sw/bin/init.sh
	# TODO: this totally borks shell startup
	# For Android
	PATH="$PATH:/Applications/Android\ SDK/tools:/Applications/Android\ SDK/platform-tools"
	# For Homebrew formulae on OS X
	PATH="/usr/local/bin:/usr/local/sbin:$PATH"
	
	# For Ruby gems. This should be done better with e.g. rvm, because Ruby upgrades will break the path, but I can't be bothered.
	export GEMPATH=/usr/local/Cellar/ruby/2.1.0/lib/ruby/gems/2.1.0/gems/
	
	##
	# Your previous /Users/alex/.bash_profile file was backed up as /Users/alex/.bash_profile.macports-saved_2013-03-16_at_00:07:13
	##
	
	# MacPorts Installer addition on 2013-03-16_at_00:07:13: adding an appropriate PATH variable for use with MacPorts.
	PATH="/opt/local/bin:/opt/local/sbin:$PATH"
	# Finished adapting your PATH environment variable for use with MacPorts.

	export PATH
fi

if [ -f /usr/bin/pacmatic ]; then
	alias pacman="pacmatic --color auto"
fi

if [ -d /opt/android-sdk/platform-tools ]; then
	export PATH="$PATH:/opt/android-sdk/platform-tools"
fi

# Unconditional because configctl ensures that this is available
PATH=$PATH:~/.bin/bin

# moz-git-tools isn't in ~/.bin/bin because it has so many binaries,
# it's just more convenient to do it this way
PATH=$PATH:~/.bin/moz-git-tools

# Colorized Pacman output
alias pacman="pacman --color auto"

#_byobu_sourced=1 . /usr/bin/byobu-launch
