# clip

clip is a small utility to manage the X clipboard sensibly.  It's
meant to be used interactively, not in scripts.

if the standard input is not a tty, slurp everything (except the last
newline!) to the clipboard

	if [ ! -t 0 ]; then
		exec xclip -r -selection clipboard >/dev/null
	fi

otherwise output its contents

	exec xclip -o -selection clipboard
