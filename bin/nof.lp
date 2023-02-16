# NOte Find

A simple script to filter notes with fzf and open them in mg(1).

=> https://gist.github.com/benevidesh/d78f7681120a13d5386ea55b39d82c9b Inspired by a gist

	cd ~/notes || exit 1

I store all the notes here, but die quickly should that directory not
exists.

	grep '^# ' * | \
		sed -e 's/:# / | /1' | \
		fzf --tac --multi --layout=reverse \
			--preview "echo {} | sed 's/ .*//g' | xargs cat" | \
		while read l; do
			xargs -o mg -- "${l%% *}" </dev/null;

I prefer this over binding enter in fzf.  `xargs -o' re-opens /dev/tty
so mg works.

The fancy `${l%% *}' thingy is just to select only the filename (i.e.
everything until the first space) and discard the rest of the line (the
title.)

		done
