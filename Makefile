BASIC = .bash_aliases .bash_logout .bash_profile .bashrc .byobu .emacs .gitconfig .gitignore .gitmodules .oh-my-zsh .profile .reportbugrc .screenrc .selected_editor .zprofile .zsh-update .zsh_favlist .zshrc .zshrc.pre-oh-my-zsh bin
DIRS= .gnupg .ssh .aptitude .config
LINK_DIRS= .config/awesome .config/cower .antigen
AFTER_DIRS=.gnupg/gpg.conf .ssh/config .aptitude/config
# TODO: set this to pwd
CONFIG_DIR=~/configs
TARGET_DIR=~/configtest

all: update install

update:
	# TODO update antigen
	# this can't be done with regular commands because it requires a zsh instance with antigen sourced
	git pull --rebase
	git submodule update --init

install:
	@echo "warning: going to make a call to ln using the -f switch"
	cd $(TARGET_DIR); mkdir -p $(DIRS)
	ln -sfrt $(TARGET_DIR) $(BASIC)
	ln -sfrt $(TARGET_DIR) $(AFTER_DIRS) # TODO this is very buggy for some reason
	ln -sfrt $(TARGET_DIR) $(LINK_DIRS)

uninstall:
	cd $(TARGET_DIR); rm $(BASIC) $(LINK_DIRS) $(AFTER_DIRS) && rmdir $(DIRS)
