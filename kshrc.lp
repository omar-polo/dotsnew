# ksh

OpenBSD ksh (sometimes called opdksh or oksh) is the default shell on
OpenBSD, and is generally my go-to choince on other systems too.  It has
a good ratio of features and simplicity

	if [ "$TERM" = dumb ]; then
		PS1='$ '
		return
	fi

Enable emacs-like command editing regardless of $EDITOR and csh-like
history expansion with !

	set -o emacs
	set -o csh-history

Talking about history, by default ksh won't store any, which is
unfortunate.  I can't live without my C-r working!

	HISTCONTROL=ignoredups:ignorespace
	HISTFILE=$HOME/.history
	HISTSIZE=10000

OpenBSD ksh has a limited support for programmed completions through
static lists.  The completions are provided via an array called
complete_$progname; or complete_$progname_$nth for the nth argument.

Here's the completions for ssh and scp:

	HOST_LIST=$(awk '/Host / {print $2}' ~/.ssh/config | xargs echo)

	set -A complete_ssh -- $HOST_LIST
	set -A complete_scp -- $HOST_LIST

and for kill(1) and pkill(1)

	set -A complete_kill_1 -- -9 -HUP -INFO -KILL -TERM
	set -A complete_pkill_2 -- -SIGHUP -SIGUSR1 -SIGUSR2 -SIGTERM -SIGKILL

and for vmd(8) if available

	if test -f /usr/sbin/vmd && pgrep -fq /usr/sbin/vmd; then
		set -A complete_vmctl_1 -- console load reload start stop \
			reset status send receive
		set -A complete_vmctl -- \
			$(vmctl status | awk '!/NAME/{printf "%s ", $NF}')
	fi

and for ifconfig(8)

	command -v ifconfig >/dev/null && \
		set -A complete_ifconfig_1 -- $(ifconfig | grep ^[a-z] | cut -d: -f1)

and for got(1)

	command -v got >/dev/null && \
		set -A complete_got_1 -- $(got -h 2>&1 | sed -n s/commands://p)

Tweak the output of ls

	alias ls='ls -F'

Provide an easiest access to amused

	alias a=amused

reset(1) doesn't work as expected inside tmux: the old output can still
be consulted when scrolling.  If I, lazy as I am, bother to type "reset"
I want to be sure that the history was cleared!

	if [ -n "$TMUX" ]; then
		alias reset='reset && tmux clear-history'
	fi

CDPATH is super useful!  I even wrote a post about it:
https://www.omarpolo.com/post/enjoying-cdpath.html

	export CDPATH=".:$HOME/w:/usr/ports:/usr/ports/mystuff:$HOME/quicklisp/local-projects"

I love to hate gpg!  It needs some special treatments to work and this
should also (finger crossed!) fix pinentry over ssh.  I'm not sure it
works though, it's been a while since I've connected remotely to my
desktop.

	export GPG_TTY=$(tty)
	if [ -n "$SSH_CONNECTION" ]; then
		export PINENTRY_USER_DATA="USE_CURSES=1"
	fi

The BSDs have this incredibly useful signal available, it's a shame not
to use it!

	case "$(uname)" in
		*BSD) stty status ^T ;;
	esac

I really like my prompt to be as minimal as possible.  For some time
I've used a single colon `;' as prompt, it's really nice!  At the moment
thought I'm usign a more plan9-esque percent sign, with an optional
hostname:

	if [ "$(hostname)" = venera ]; then
		PS1='% '
	else
		PS1='\h% '
	fi

I got tired of trying to remember the set of flags for nc to walk to
Gemini servers, so here we are:

	# "post" stdin to the gemini server
	# usage: gem host [port]
	gem()
	{
		host="${1:?missing host}"
		port="${2:-1965}"
		nc -c -Tnoverify "${host}" "${port}"
	}

I think I've stolen these from someone.  It makes a copy of the file and
launch an editor on the original file, incledibly useful when working
with ports (that's why doas!)

	mgdiff()
	{
		if [ -z "$1" ]; then
			printf "%s\n" "USAGE: mgdiff file" >&2
			return
		fi
		doas cp -p "$1" "$1.orig"
		doas mg "$1"
	}

hist is a quick wrapper around history and grep to quickly search for a
previous command:

	hist()
	{
		if [ -z "$1" ]; then
			printf "%s\n" "USAGE: hist pattern" >&2
			return 1
		fi
		history 0 | grep "$1"
	}

clbin (the site) is a web pastebin that's easy to use from the command
line with curl.  clbin (the function) is an easy way to share something,
just pipe it to clbin and it returns an url.

	clbin()
	{
		curl -F 'clbin=<-' https://clbin.com
	}

Some aliases I use when working with the OpenBSD port tree:

	alias m="make"
	alias mup="make update-patches"
	alias mupl="make update-plist"
	alias mpldc="make port-lib-depends-check"
	alias pbuild="env MAKE_JOBS=5 time make"
	alias build="pbuild 2>&1 | tee build"
	alias pclean='make clean="package plist"'

This one is pretty sophisticated, I've stolen it from jca@

	# check shared libs version
	cshlib() {
		local cnt=0
		local f

		for f in $(make show=SHARED_LIBS); do
			[ "$((cnt++ % 2))" -eq 1 ] && continue
			echo '===>' $f
			/usr/src/lib/check_sym /usr/local/lib/lib$f.so* \
				$(make show=WRKINST)/usr/local/lib/lib$f.so*
		done
	}

And even more aliases:

	alias mopnew="mdirs ~/Maildir/op | grep -v emacs | mlist -st | mthread -r | mseq -S; mscan"

	for c in com rep fwd bnc; do
		local _mvisual='mg -f auto-fill-mode'
		if [ -n "$DISPLAY" ]; then
			_mvisual='emacsclient -c'
		fi

		alias m$c="VISUAL='$_mvisual' m$c"
		alias o$c="m$c -from 'Omar Polo <op@openbsd.org>'"
	done

And finally some aliases for mq

	alias pnq="NQDIR=/tmp/ports/ nq "
	alias pfq="NQDIR=/tmp/ports/ fq "

Stuff to use my own purritobin instance

	: ${P_SERVER=paste.omarpolo.com}
	: ${P_PORT=42069}
	: ${P_TIME=week}
	: ${P_MAXTIME=30}

shell client to upload a plaintext message

	purr() {
		curl --silent --max-time "${P_MAXTIME}" \
			--data-binary "@${1:-/dev/stdin}" \
			"${P_SERVER}:${P_PORT}/${P_TIME}"
	}

shell client to upload an encrypted message

	meow() {
		key="$(openssl rand -hex 32)"
		iv="$(openssl rand -hex 16)"
		url="$(openssl enc -aes-256-cbc -K ${key} -iv ${iv} -e -base64 -A < ${1:-/dev/stdin} | purr)"
		printf "%s\n" "${url%\/*}/paste.html#${url##*\/}_${key}_${iv}"
		unset key iv url
	}

...and to decrypt it

	meowd() {
		url="$1"
		baseurl="${url%\/*}"
		vals="${url##*\#}"
		paste=$(printf '%s\n' "${vals}" | cut -d_ -f1)
		key=$(printf '%s\n' "${vals}" | cut -d _ -f2)
		iv=$(printf '%s\n' "${vals}" | cut -d _ -f3)
		curl --max-time "${P_MAXTIME}" --write-out "\n" --silent \
			"${baseurl}/${paste}" | openssl enc -aes-256-cbc \
			-base64 -d -K ${key} -iv ${iv}
		unset url baseurl vals paste key iv
	}

a little awk oneliner to show the stats of a unified diff

	diffstat() {
		awk '
		/^\+/ { a++; next }
		/^\-/ { m++; next }
		END   { printf("additions:\t%d\nremoval:\t%d\n", a, m) }
		'
	}

find(1) is an invaluable tool and I use it all the time.  walk is an
attempt to build a wrapper around some common usages of find that is a
little bit less verbose to use.  The name is stolen from 9front, but the
implementation is completely different.

	# usage: walk [dir] [type] [name regexp] [! command to execute]
	walk()
	{
		if [ $# -eq 0 ]; then
			find .
			return
		fi

		local dir=.
		local type=
		local name=\*

		if [ -n "$1" -a -d "$1" ]; then
			dir="$1"
			shift
		fi

		case "$1" in
		b|c|d|f|l|p|s)
			type="-type $1"
			shift
		esac

		if [ -n "$1" -a "x$1" != "x!" ]; then
			name="$1"
			shift
		fi

		if [ "x$1" = x! ]; then
			shift
		fi

		if [ $# -eq 0 ]; then
			find "$dir" $type -iname "$name"
		else
			find "$dir" $type -iname "$name" -exec "$@" {} +
		fi
	}
