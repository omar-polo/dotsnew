# mquote

mquote - format MSG as a quotation.

This is a tweaked copy of mquote from mblaze that adds the date of the
original message.

	#!/bin/sh

Extract the sender

	: ${from:=$(mhdr -d -h x-original-from "$1")}
	: ${from:=$(mhdr -d -h from "$1")}
	: ${from:=Someone}

and the date

	pfmt="%a, %d %b %Y %H:%M:%S %z"
	: ${date:=$(mhdr -d -h date "$1")}
	date="${date:+$(dateconv -f "$pfmt" "$date")}"

	printf '%s%s wrote:\n' "${date:+On $date, }" "$from"

Then strip the signature, empty lines and prefix everything with ">"

	{ mshow -R "$1" || mshow -h '' -N "$1"; } |
		sed -n '/^-- $/,$!p'   |
		sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' |
		sed 's/^/> /'
