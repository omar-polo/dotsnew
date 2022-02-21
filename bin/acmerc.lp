# acmerc

I'm using this script to spawn acme on OpenBSD in all its glory!

	#!/usr/bin/env rc

	. $home/lib/profile

	if (~ $PLAN9 '') {
		echo '$PLAN9 is not defined!'
		exit 1
	}

Provide a sane environment for acme

	SHELL=rc
	PAGER=nobs
	MANPAGER=nobs
	EDITOR=editinacme
	VISUAL=editinacme

Most of the utilities from plan9ports binds sockets in NAMESPACE, which
is /tmp/ns.$USER.$DISPLAY by default.  I'd like to have different
namespaces per acme session, so I'm defining the env variable.

Yes, using $pid ($$ in bourne shell) is discouraged to generate "random"
values, but here it's done on puropese: every program spawned inside
*this* terminal will share the same namespace.

	NAMESPACE=/tmp/ns.$user.$pid
	mkdir -p $"NAMESPACE

Start the plumber and fontsrv

	plumber
	fontsrv &
	fontsrvpid=$apid

I've used Go Mono for a while, but I'm falling in love with bitmaps
fonts these days

	font=/usr/local/plan9/font/fixed/unicode.7x14.font
	# font=/mnt/font/GoMono/10a/font
	FONT=/mnt/font/InputSans-Regular/10a/font

Start acme for real

	$PLAN9/bin/acme -a -f $font -F $FONT $* &
	acmepid=$apid

wait a bit for acme to set up its things and start autoacme

	{
		sleep 1
		winid=1
		exec acmeeval 'autoacme '$home'/bin/acmeconfig'
	}
	acmeevalpid=$apid

Then wait for acme to terminate

	wait $acmepid

and stop acmeeval (just in case) and fontsrv

	kill $acmeevalpid
	kill $fontsrvpid

wait a little bit more

	wait # just in case

and then kill the namespace before quitting

	rm -rf $"NAMESPACE
