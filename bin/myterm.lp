# myterm

	#!/bin/ksh

A wrapper script to launch xterm with a cute random background color.

Got the idea from deadpixi' sam fork (the editor), where one can pass a
list of colours as `background' and sam will use a random one.

I'm actually using the same list of the sam example configuration:

	set -A colours white seashell oldlace lightcyan \
		lightyellow mintcream snow

ksh has not a great syntax for arrays, but this will choose (with modulo
bias!) a random colour and use it as xterm background.

	exec xterm -bg "${colours[$((RANDOM % ${#colours[@]}))]}" "$@"
