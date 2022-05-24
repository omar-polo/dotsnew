# mg -- micro emacs

mg is an Emacs clone.  Well, it's more minimal, it doesn't have any
scripting language etc, but it has mostly the same keybindings as Emacs.
Having it in base on OpenBSD is a Godsent.

	set-fill-column 72
	meta-key-mode

Set some defaults.  `meta-key-mode' in particular is incredibly helpful
because it allows to enter non-ASCII characters.  mg still doesn't know
how to render those (so you get "\303\250" instead of è), but at least
you can input them!

	backup-to-home-directory

I don't like to have the whole filesystem dirtied by all those backup
files.  This moves them in ~/.mg.d in case I need them.

	define-key compile "n" next-line
	define-key compile "p" previous-line
	define-key compile "q" delete-window

Mg doesn't have many (any?) keybindings defined in compile-mode.  This
turns it into something that resambles Emacs a bit more and it's
handier.

	global-set-key "\^cm" compile
	global-set-key "\eg\eg" goto-line

compile is handy to have and while here bind "M-g M-g" to goto-line,
just as in Emacs.

	auto-execute *.[ch] c-mode
	auto-execute *.[ch] auto-fill-mode

	auto-execute README* auto-fill-mode
	auto-execute *.txt auto-fill-mode
	auto-execute *.md auto-fill-mode
	auto-execute *.[1-9] auto-fill-mode

	auto-execute * auto-indent-mode

`auto-execute' is similar to add-hook.  Set some default stuff for files
matching those patterns.
