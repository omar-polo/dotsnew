# event-gen

This script is the event generator for the bar.  The ideas is that
it sits waiting for stuff to happen (window focus, date change,
music player, ...)

	#!/usr/bin/env rc

	. ./lib

Kill the player monitor and the date subshell upon exit

	fn quit {
		kill $datepid
		kill $playerpid
	}

	fn siguhp { quit }
	fn sigint { quit }

The idea behind `uniq_linebuffered' is to avoid refreshing the bar
every tick if the state doesn't change.  It doesn't work for some
reason however...

	# XXX: for some reasons this don't work
	fn uniq_linebuffered {
		awk '$0 != l { print ; l=$0 ; fflush(); }'
	}

Simulate the tag and play event at the start to force the process
to update the tags and music info.

	echo tag
	echo play

Date event generator:

	while () {
		date=`{date +'%H:%M, %Y-%m-%d'}
		printf 'date\t%s\n' $"date
		sleep 10 || break
	} | uniq_linebuffered &
	datepid=$apid

Music player event generator:

	amused monitor | egrep --line-buffered '(play|next|prev)' &
	playerpid=$apid

Window manager event generator:

	hc --idle

Kill everything upon exit

	quit
