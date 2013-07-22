#.bash_profile

if [ $(uname -s) == "Darwin" ]; then
	# For distributed.net client
	PATH=$PATH:/Applications/dnetc518-macosx-x86
	# For MacPorts
	PATH=$PATH:/opt/local/bin:/opt/local/sbin
	# For Fink
	test -r /sw/bin/init.sh && . /sw/bin/init.sh
	# For Android
	PATH=$PATH:"/Applications/Android SDK/tools":"/Applications/Android SDK/platform-tools"
	
	##
	# Your previous /Users/alex/.bash_profile file was backed up as /Users/alex/.bash_profile.macports-saved_2013-03-16_at_00:07:13
	##
	
	# MacPorts Installer addition on 2013-03-16_at_00:07:13: adding an appropriate PATH variable for use with MacPorts.
	export PATH=/opt/local/bin:/opt/local/sbin:$PATH
	# Finished adapting your PATH environment variable for use with MacPorts.
fi

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
