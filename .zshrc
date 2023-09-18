# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Operating system detection
if [[ -a /etc/os-release ]]; then source /etc/os-release; fi
if [[ NAME == "Arch Linux" ]]; then
	DISTRO=ARCH
fi
if [[ $(uname -s) == Darwin ]]; then
	DISTRO=DARWIN
else if [[ $(uname -o) == Cygwin ]]; then
	DISTRO=CYGWIN
fi
fi

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
if [[ -z $ZSH_THEME ]]; then
	ZSH_THEME="mortalscumbag"
fi

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
#COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
base_plugins=(git cp rails mercurial colorize battery colored-man-pages history-substring-search toolbox)

# Generic base plugins
plugins=($base_plugins)

# Arch Linux plugins
if [[ $DISTRO == ARCH ]]; then
	plugins=($base_plugins archlinux)
fi

# Mac OS X plugins
if [[ $DISTRO == DARWIN ]]; then
	plugins=($base_plugins osx brew)
fi

# Use Antigen
source ~/antigen/antigen.zsh

antigen bundles <<EOF
	zsh-users/zsh-syntax-highlighting
EOF

antigen apply

# We load zsh after Antigen because apparently history-substring-search is incompatible with zsh-syntax-highlighting
source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# done in .profile nowadays
# export PATH=$PATH:~/bin

# TODO
if [ -d ~/.local/bin/ ]; then
	export PATH=$PATH:~/.local/bin/
fi

# Load user-level completions. This is here because it's an extension, not POSIX.
source ~/.bin/bash_completion/*

if [[ $(hostname) == steevie ]]; then
	autoload -U up-line-or-beginning-search
	autoload -U down-line-or-beginning-search
	zle -N up-line-or-beginning-search
	zle -N down-line-or-beginning-search
	bindkey "^[[A" up-line-or-beginning-search # Up
	bindkey "^[[B" down-line-or-beginning-search # Down
fi

source ~/.zprofile

# This would be better in .profile, but unfortunately that needs to be only POSIX and POSIX doesn't have `command`
function git() {
	if [[ $1 == 'log' ]]; then
		shift
		command git log --graph --decorate $@
	else
		command git $@
	fi
}

# nvm
# When in .profile this script throws parse errors because of emulate sh -c
export NVM_DIR="$HOME/.nvm"
if [[ -f /usr/share/nvm/init-nvm.sh ]]; then
	source /usr/share/nvm/init-nvm.sh
fi
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

type pyenv >/dev/null && eval "$(pyenv init -)"

# See /usr/share/zsh/functions/Misc/run-help; this seems like it's supposed to work out of the box but doesn't?
# TODO report this bug to Debian
[[ -d /usr/share/zsh/help ]] && local HELPDIR=${HELPDIR:-/usr/share/zsh/help}

set -o EXTENDED_GLOB
set -o KSH_GLOB
# Install run-help helpers
# The pattern that looks like voodoo matches ZSH version numbers, equivalent to [[:digit:].]+ in regex
for i in /usr/share/zsh/(+([[:digit:].])/)#functions/(Misc/)#run-help-*(:t); do
	autoload -Uz $i
done

# Misc
autoload -Uz tetris
autoload -Uz tetriscurses
