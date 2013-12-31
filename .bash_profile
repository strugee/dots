#.bash_profile

# For personal scripts saved in ~/bin
export PATH=$PATH:~/bin

# Add .bashrc stuff
[[ -f ~/.bashrc ]] && . ~/.bashrc

# this includes env variables
[[ -f ~/.profile ]] && . ~/.profile

if [ -a /etc/hostname ]; then if [[ $(cat /etc/hostname) == "alex-ubuntu-server" ]]; then
	echo -e "\nYou've succesfully connected to the system.\nIdeally, you would keep a terminal session open while interacting with the system in order to recieve system broadcasts."
	#_byobu_sourced=1 . /usr/bin/byobu-launch -S byobu
	#byobu -R -S byobu;exit
	echo "screen disabled due to bugs"
fi; fi
