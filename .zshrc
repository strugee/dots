# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Operating system detection
if [[ -a /etc/os-release ]]; then source /etc/os-release; fi
if NAME="Arch Linux" then
	DISTRO=ARCH
fi
if [ $(uname -s) = Darwin ]; then
	DISTRO=DARWIN
fi

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
if [[ -z $ZSH_THEME ]]; then
	ZSH_THEME="dogenpunk"
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
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
base_plugins="git cp rails hg colorize command-not-found battery colored-man"

# Generic base plugins
plugins=($base_plugins)

# Arch Linux plugins
if DISTRO=ARCH then
	plugins=($base_plugins archlinux)
fi

# Mac OS X plugins
if DISTRO=DARWIN then
	plugins=($base_plugins osx brew)
fi

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# done in .profile nowadays
# export PATH=$PATH:~/bin

# TODO
# should probably be in .profile, since it's generic to all shells.
if DISTRO=DARWIN then
	export PATH=/usr/local/bin:$PATH
fi
