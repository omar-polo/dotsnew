# dotfiles

Welcome to my new-new-new dotfiles repository!

My last attempt to manage them was with org-mode, a terrific Emacs lisp
program.  It's really cool, but I never wanted to invest time in
learning it properly, so here we are.  I guess I could cite Ken Thompson

> I can't understand something presented to me that's very complex.

but it wouldn't be completely true.  I understand and use complex stuff,
but some I just don't want to put the effort in.

This is me reinventing a lightweight literate-programming style (mostly
in AWK) and use it to manage my dotfiles, as well as for exporting them
for the Geminispace and the WWW.

To start using it:

	$ ./gen			# generates Makefile.local
	$ make install		# installs the dotfiles
	$ make publish		# publishes for gemini and www
	$ make serve-www	# serve the www site locally
	$ make serve-gem	# serve the gemini site locally

There are quite a few scripts that I think can be useful to other
people:

* unpar: gathers paragraphs and simple list that spans multiple lines
  into a single line; in other words it converts "markdown"-style
  paragraphs and lists to text/gemini.

* gc: converts lines indented with tabs into markdown/gemtext style
  fenced code blocks.

* gem2html: perl script that converts text/gemini to HTML with care.
