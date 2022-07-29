# profile

I don't know how "portable" a .profile can be, but let's try!

Althought I'm not using acme as my go-to text editor program, I still
like to use it and have the rest of the plan9ports at hand.

I manually fetched and installed the ports in /usr/local/plan9, and need
to define $PLAN9 in order for the various tooling to work.

	PLAN9=/usr/local/plan9
	export PLAN9

I tend to have an abnormal $PATH

	PATH=$HOME/bin:$HOME/opt/emacs/bin:$HOME/opt/gcc10/bin:$HOME/go/bin:$HOME/opt/unnethack/bin:$HOME/.local/bin:$HOME/.node_modules/bin:/home/ports/infrastructure/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:/usr/local/jdk-11/bin:$PLAN9/bin

Let's split it:

* $HOME/bin is for my personal scripts, needs to take precedence over anything else
* $HOME/opt/* contains various stuff I compile from source, like Emacs
* $HOME/.local/bin is XDG stuff I'm practically forced to use
* $HOME/.node_modules/bin is for node
* /usr/ports/infrastructure/bin is for handy port tools
* the rest is just the usual $PATH on OpenBSD with java and plan9 pushed at the end

Tell npm to install things globally in the right directory

	export npm_config_prefix=~/.node_modules

Just in case I want to play with lua again:

	if which luarocks-5.3 >/dev/null 2>&1; then
		eval "$(luarocks-5.3 path --bin)"
	fi

ksh doesn't have a "default" configuration file (like ~/.zshrc or
~/.bashrc); instead, if called interactively, it loads the file pointed
by ENV.  Tell ksh to load ~/.kshrc then

	export ENV=$HOME/.kshrc

An UTF-8 locale is mandatory.  I'm using en_US even if english is not my
main language:

	export LANG=en_US.UTF-8

Got is quickly becoming my favourite version control system.  It should
be able to load the author data from a config file, but I still keep
this variable, just in case :)

	export GOT_AUTHOR="Omar Polo <op@omarpolo.com>"

Sometimes I need to do stuff with Docker.  I have a virtual machine
running alpine with docker configured and this bit here will allow
docker-cli to transparently talk to the VM:

	export DOCKER_HOST=ssh://op@100.64.2.3:22

I like to use mg as my default editor but under vterm is a bit of a pain
because emacs keeps eating up all the various C-c and C-x keys.  Thus,
switch back to vi when INSIDE_EMACS (which sounds strange, I know)

	if [ -z "$INSIDE_EMACS" ]; then
		VISUAL=mg
		EDITOR=mg
	else
		VISUAL=vi
		EDITOR=vi
	fi

	export VISUAL EDITOR

less(1) should be the default pager pretty most everywhere, but ensure
that!

	export MANPAGER=less

I've found a cool pager for postgresql, pspg.  It's designed explicitly
for tabular data.  Extra points for having some cool light themes!  Tao
light theme (number 20) is my favourite.

	export PSQL_PAGER='pspg -s20'

I'm using reposync to manage my local clone of the OpenBSD source tree.
Technically this isn't needed, because /home/ports is already a checkout
from /home/cvs, but anyway...

	export CVSROOT=/home/cvs

This is just to make some command outputs a little bit nicer:

	export BLOCKSIZE=1m

I don't particularly like coloured outputs when I'm in front of a
terminal, so I tend to disable them:

	export NO_COLOR='yes, please'
	export CMAKE_COLOR_MAKEFILE=OFF
	export WG_COLOR_MODE=never

...as an exception I'm trying to enable colors in tog(1) (cautiously!)
and see how it goes:

	export TOG_COLORS=yes
	export TOG_COLOR_DIFF_MINUS=magenta
	export TOG_COLOR_DIFF_PLUS=blue
	export TOG_COLOR_DIFF_CHUNK_HEADER=green
	export TOG_COLOR_DIFF_META=default
	export TOG_COLOR_COMMIT=default
	export TOG_COLOR_AUTHOR=default
	export TOG_COLOR_DATE=default
	export TOG_COLOR_REFS_REMOTES=red

some other tweaks for tog

	export TOG_DIFF_ALGORITHM=patience
	export TOG_VIEW_SPLIT_MODE=h

mblaze uses quoted-printable if there are lines longer than 78 character
or so.  if $MBLAZE_RELAXED_MIME is specified tho, it will only do so if
it founds lines longer than 998 characters, allowing me to send diffs
without mangling!

	export MBLAZE_RELAXED_MIME=1

On OpenBSD, automake and autoconf requires these variables to be up to
work.  Otherwise one can run automake-X.Y and autoconf-X.Y, but that's
ugly:

	export AUTOCONF_VERSION=2.69
	export AUTOMAKE_VERSION=1.16

Finally, load the specific profile for this machine if it exists:

	if [ -f "$HOME/.profile-local" ]; then
		. "$HOME/.profile-local"
	fi
