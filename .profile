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
export PATH=~/bin:$PATH
export EDITOR=nano
export VISUAL=emacs
export PAGER=less
if [ -n "$DISPLAY" ]; then
	export BROWSER=firefox
else
	export BROWSER=lynx
fi

# add the sbins to the path on Debian, because it bugs me that they aren't there by default
if [ -f /etc/os-release ]; then
	# could probably be done better, e.g. using a function or bash -c.
	# as it stands, this pollutes the global scope. I don't really care though, so I probably won't fix it.
	source /etc/os-release
	if [ $NAME = "Debian GNU/Linux" ]; then export PATH=/sbin:/usr/sbin:$PATH; fi
fi


if [ $(uname -s) = "Darwin" ]; then
	# For distributed.net client
	PATH=$PATH:/Applications/dnetc518-macosx-x86
	# For MacPorts
	PATH=$PATH:/opt/local/bin:/opt/local/sbin
	# For Fink
	test -r /sw/bin/init.sh && . /sw/bin/init.sh
	# For Android
	PATH=$PATH:"/Applications/Android SDK/tools:/Applications/Android SDK/platform-tools"
	# For Homebrew formulae on OS X
	PATH=/usr/local/bin:/usr/local/sbin:$PATH

	##
	# Your previous /Users/alex/.bash_profile file was backed up as /Users/alex/.bash_profile.macports-saved_2013-03-16_at_00:07:13
	##
	
	# MacPorts Installer addition on 2013-03-16_at_00:07:13: adding an appropriate PATH variable for use with MacPorts.
	PATH=/opt/local/bin:/opt/local/sbin:$PATH
	# Finished adapting your PATH environment variable for use with MacPorts.

	export PATH
fi

if [ -f /usr/bin/pacmatic ]; then
	alias pacman=pacmatic
fi

# Colorized Pacman output
alias pacman="pacman --color auto"

#_byobu_sourced=1 . /usr/bin/byobu-launch
