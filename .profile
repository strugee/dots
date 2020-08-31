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

# load PAM environment if the system doesn't do it for us
if [ -z ${PAM_ENVIRONMENT_SET+x} ]; then
	eval $(sed 's/^/export /g' "$HOME/.pam_environment")
fi

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
	export BROWSER=firefox-nightly
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

if ! [ $(uname) = Darwin ] && type ruby >/dev/null && type gem >/dev/null; then
	# Fix Bundler behavior on Arch
	export GEM_HOME="$(ruby -e 'print Gem.user_dir')"
	# Add local Gems to PATH
	PATH="$GEM_HOME/bin:$PATH"
fi

# add the sbins to the path on Debian, because it bugs me that they aren't there by default
if [ -f /etc/os-release ]; then
	# could probably be done better, e.g. using a function or bash -c.
	# as it stands, this pollutes the global scope. I don't really care though, so I probably won't fix it.
	. /etc/os-release
	if [ "$NAME" = "Debian GNU/Linux" ]; then export PATH=/sbin:/usr/sbin:$PATH; fi
fi

if [ $(uname -s) = "Darwin" ]; then
	# For distributed.net client
	PATH="$PATH:/Applications/dnetc518-macosx-x86"

	# For Homebrew formulae on OS X
	PATH="/usr/local/bin:/usr/local/sbin:$PATH"

	# For Android
	PATH="/Applications/Android SDK/tools:/Applications/Android SDK/platform-tools:$PATH"

	# Metasploit
	PATH="$PATH:/opt/metasploit-framework/bin"

	export PATH

	export NVM_DIR="$HOME/.nvm"
	. $(brew --prefix nvm)/nvm.sh

	export BROWSER=/Applications/Firefox\ Nightly.app/Contents/MacOS/firefox
fi

test -d /opt/android-sdk/platform-tools && export PATH="$PATH:/opt/android-sdk/platform-tools"

# Hyak
if type qsub >/dev/null; then
	PATH="/com/local/bin:$PATH"
	alias big_machine='qsub -W group_list=hyak-mako -l walltime=500:00:00,mem=200gb -I'
	alias any_machine='qsub -W group_list=hyak-mako -l walltime=500:00:00,mem=100gb -I'
	export PYTHON_PATH="/com/local/lib/python3.4:$PYTHON_PATH"
	export LD_LIBRARY_PATH="/com/local/lib:${LD_LIBRARY_PATH}"
	export PKG_CONFIG_PATH=/com/local/lib/pkgconfig:/usr/share/pkgconfig
	export MC_CORES=16
	umask 007
fi

test -d "$HOME/.cargo/bin" && export PATH="$HOME/.cargo/bin:$PATH"

# Unconditional because configctl ensures that this is available
PATH=~/.bin/bin:$PATH

# moz-git-tools isn't in ~/.bin/bin because it has so many binaries,
# it's just more convenient to do it this way
PATH=$PATH:~/.bin/moz-git-tools

PATH=$PATH:~/.bin/filter-other-days/bin

test -d /snap/bin && PATH=$PATH:/snap/bin

# Expand aliases for sudo
# https://unix.stackexchange.com/a/148548/29146
alias sudo='sudo '

# Colorize Pacman output; assume Pacmatic is available everywhere because I'd rather fail than get plain Pacman
alias pacman="pacmatic --color auto"

alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"

alias upload-weekly-report="scp ~/ownCloud/gap-year-time-tracking.html steevie:public_html/gap-year-reports.html"

alias now="date +%s | tr -d '\n'"

alias borgfd='ls -l /proc/$(pidof -x borg)/fd'

#_byobu_sourced=1 . /usr/bin/byobu-launch

proc_inotify=/proc/sys/fs/inotify/max_user_instances
if grep set-inotify ~/configs/local-config >/dev/null 2>&1 && test -f $proc_inotify && [ $(cat $proc_inotify) != 50000 ]; then
	echo 50000 | sudo tee $proc_inotify > /dev/null
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
