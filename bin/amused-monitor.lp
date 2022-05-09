# amused-monitor

This is a small interface for the amused music player

=> https://projects.omarpolo.com/amused.html amused

	#!/usr/bin/env rc

It's written in rc because I found easier to manage subprocesses in it
rather than in sh.

There are two main processes involved: input and ui.  The input
process handles the keybindings and controls amused, the ui input
waits for some events and redraws the interface.

	fn input {
		ifs=()

$ifs needs to be set to the empty list (or empty string), otherwise
we're not able to read spaces as keybindings.

		run=1
		while (~ $run 1) {

rc lacks a break statement, so I'm using a flag variable to quit
looping.

			stty raw
			t=`{dd bs=1 count=1 status=none}
			stty cooked

This is just a trick to read without echoing back the characters.

			switch ($"t) {
			case n
				amused next
			case p
				amused prev
			case ' '
				amused toggle
			case s
				amused stop
			case q
				run=0
			case *
				printf ' unknown keybinding >'$t'<\r'
			}
		}
	}

The ui functions render the interface.  I'd like to keep a small xterm
open, that's why I'm narrowing (with grep -A -B) only to the songs
around the currently played one.

	fn ui {
		clear
		amused show -p | grep -A3 -B3 '^>' | awk '{printf "%s\r\n", $0}'

The awk trick deserves an explanation.  Since the input function is
very likely running, the terminal is in "raw" mode: we need \r to
reposition the character at the start of the line.

	}

The uiloop function is the driver for the ui process: it listens to
interesting events and redraws the ui when they happen

	fn uiloop {
		amused monitor | egrep --line-buffered 'next|prev|pause' | {
			while (read) {
				ui
			}

A small note of merit: unlike other shells read is not a built in in
rc bur rather an external command (/usr/local/plan9/bin/read here.)

		}
	}

And that's all.  I only need to launch the functions in the correct
order and do one render at the start and amused-monitor is done!

	ui
	uiloop &
	uipid=$apid
	input
	kill -INT -$uipid




