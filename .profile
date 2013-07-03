export PATH=~/bin:$PATH
export EDITOR=nano
export VISUAL=emacs
export PAGER=less
if [ -n "$DISPLAY" ]; then
	export BROWSER=firefox
else
	export BROWSER=lynx
fi
