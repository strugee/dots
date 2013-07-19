#.bash_profile

echo -e "\nYou've succesfully connected to the system.\nIdeally, you would keep a terminal session open while interacting with the system in order to recieve system broadcasts."

# For scripts saved in ~/bin
export PATH=$PATH:~/bin

# Add .bashrc stuff
[[ -f ~/.bashrc ]] && . ~/.bashrc

# this includes env variables
[[ -f ~/.profile ]] && . ~/.profile

if [[ $(cat /etc/hostname) == "alex-ubuntu-server" ]] then
	#_byobu_sourced=1 . /usr/bin/byobu-launch -S byobu
	byobu -R -S byobu;exit
fi
