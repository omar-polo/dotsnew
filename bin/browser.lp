# browser

This is my default browser.  It launces the connect program depending on
what is currently running:

	#!/bin/sh

	if pgrep firefox >/dev/null 2>&1; then
		exec firefox "$1"
	fi

	if pgrep iridium >/dev/null 2>&1; then
		exec iridium "$1"
	fi

with a sane deafult

	exec firefox "$1"
