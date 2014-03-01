BASIC = .aptitude .bash_aliases .bash_logout .bash_profile .bashrc .byobu .emacs .gitconfig .gitignore .gitmodules .oh-my-zsh .profile .reportbugrc .screenrc .selected_editor .zprofile .zsh-update .zsh_favlist .zshrc .zshrc.pre-oh-my-zsh bin
DIRS= .gnupg .ssh .config

all: update install

update:
	# TODO update antigen
	# this can't be done with regular commands because it requires a zsh instance with antigen sourced
	git pull --rebase
	git submodule update --init


install:
	cd ..
	mkdir -p $(DIRS)
	# TODO install BASIC

uninstall:
	cd ..
	rm $(BASIC)
