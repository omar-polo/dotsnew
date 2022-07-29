# gamemode

Switches the mice and keyboard back and forth from my custom setup to a
'normal' one.

	#!/bin/sh

	set -e

	btn1=$(xmodmap -pp | awk '/ 1 / {print $2}')
	if [ "$btn1" = 3 ]; then	# switch to dx mouse + us
		xmodmap -e 'pointer = 1 2 3'
		setxkbmap us
	else				# switch to sx mouse + dvp-eu
		xmodmap -e 'pointer = 3 2 1'
		grep ^setxkbmap ~/.xsession | sh
	fi

cwm sometime needs an "encouragement" when switching keyboard layout.

	pkill -HUP cwm || true
