# sshot

sshot is a simple script to make a screenshot!

	#!/bin/sh
	
	select=
	while getopts s name; do
		case $name in
		s)	select=1 ;;
		?)	echo "Usage: $0 [-s]" >&2; exit 1 ;;
		esac
	done

The usage is simple, it just accepts a -s flag to select a window
instead of grabbing the whole screen.

The image is saved in /tmp/YYYYMMDDHHMMSS.png

	file=/tmp/`date +%Y%m%d%H%M%S`.png

	if [ -n "$select" ]; then
		maim -su > "$file"
	else
		maim -u > "$file"
	fi

During the "select" maim aborts if a key is pressed; this however leaves
a zero-byte file around, something I don't really like, so remove it in
case

	if [ $? -ne 0 ]; then
		rm "$file"
		notify-send "sshot: aborted"
		exit 1
	fi

Then send a notification to give a feedback of the success

	notify-send "sshot: done" "$file"
