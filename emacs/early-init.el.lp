# early init

Starting from GNU Emacs 27 there is an additional configuration file
called `early-init.el'.  As the name suggest, this is called *before*
the usual `init.el' or `.emacs'.  There are some small tweaks we can
do here to improve startup performance and to declutter the `init.el'

	(menu-bar-mode -1)
	(tool-bar-mode -1)
	(scroll-bar-mode -1)
	(horizontal-scroll-bar-mode -1)

It's also a great place to tweak the `load-path'!

	(add-to-list 'load-path
	             (expand-file-name "lisp" user-emacs-directory))

Another thing I do here is to load the theme.  I've developed my own
theme (minimal-light, a fork of the original), but I'm playing with
modus now

	(load-theme 'minimal t)

and just a reminder for myself, these are some wip settings for modus
vivendi in case I want to play with it again in the future:


	;; (setq modus-themes-mode-line '(accented borderless))
	;; (setq modus-themes-region '(accented bg-only))
	;; (setq modus-themes-completions '((matches . (underline light))
	;;                                  (selection . (underline light))
	;;                                  (popup . (accented))))

Also, $CDPATH works strange in eshell so disable it:

	(setenv "CDPATH" nil)
