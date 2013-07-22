# For personal scripts
PATH=$PATH:~/bin

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

