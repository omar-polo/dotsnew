# diffstat

Show diff statistics.

	#!/usr/bin/awk -f

AWK is great.  All hail AWK!

First, some utility functions.  parsehdr extracts the number of lines
(old or new) in the given hunk header line.

	function parsehdr(s) {
		s = gensub(".*,", "", 1, s)
		s = gensub("^-", "", 1, s)
		return s + 0
	}

filename extracts the name of the file from a "+++ path" or "--- path"
line.

	function filename(s) {
		s = gensub("^... ", "", 1, s)

These lines have an optional tab followed by extra informations (the
date for example) that needs to be removed too.

		s = gensub("\t.*", "", 1, s)
		return s
	}

Switches the current file to the one provided.  It's a great place where
accumulate part of the summary showed at the end and to reset the
per-file counters.

	function switchfile(newfile) {
		if (file != "") {
			summary = sprintf("%s%4d+ %4d-\t%s\n",
			    summary, add, rem, file)
		}

		add = 0
		rem = 0
		file = newfile
	}

Now, the real "parser".  Initialize the state to "out" since we're
looking for the start of a diff.

	BEGIN {
		state = "out"
	}

Parse the changed file.

	state == "out" && /^\+\+\+ / {
		nfile = filename($0)
		if (nfile == "/dev/null") {

When deleting a file, the name will be "/dev/null", but it's not a great
name for the stats.  Let's use the "old" name instead.

			nfile = delfile
		}

		switchfile(nfile)
		delfile = ""
	}

Similarly, extract the "old" file name for when it's needed.

	state == "out" && /^--- / && file == "" {
		delfile = filename($0)
	}

Match the start of a hunk

	state == "out" && /^@@ / {

This part is a bit complicated, but all it does is extracting the number
of "new" and "old" lines showed in the hunk.  A hunk header looks like this
(except for the initial '#' character)

		# @@ -55,7 +55,19 @@ ...

So first extract the text inside the pair of "@@"

		s = gensub("@@ ", "", 1)
		s = gensub(" @@.*", "", 1, s)

and then parse each number.

		old = gensub(" .*", "", 1, s)
		old = parsehdr(old)

		new = gensub(".* ", "", 1, s)
		new = parsehdr(new)

Don't forget to switch the state of the parser, now we're reading a
hunk.

		state = "in"
	}

Keep count of the added and removed line.  Also, decrement the "old" and
"new" lines when needed, to know when we're done with the hunk.

	state == "in" && /^ / {
		old--
		new--
	}

	state == "in" && /^-/ {
		old--
		rem++
		totrem++
	}

	state == "in" && /^\+/ {
		new--
		add++
		totadd++
	}

When there are no more "new" and "old" lines to read, go back to the
"out" state, ready to read another hunk or another file.

	state == "in" && old <= 0 && new <= 0 {
		state = "out"
	}

Don't be a sink!  Continue the pipeline so we can further save or apply
the diff.

	// { print $0 }

At the end, print the stats.

	END {

It's better to flush the output here, otherwise the stats (printed to
stderr and unbuffered) may be interleaved with the output (on stdout,
buffered.)

		fflush()

Generate the stat summary for the last processed file

		switchfile("")

Print the stat to the standard error, to avoid "changing" the patch.

Unfortunately, there doesn't seem to be a "built-in" way of printing to
stderr other than using the pseudo-device "/dev/stderr".

		printf("%s", summary) > "/dev/stderr"
		printf("%4d+ %4d-\ttotal\n", totadd, totrem) > "/dev/stderr"
	}

Some example usages:

* cvs -q diff | diffstat > /tmp/diff
* got diff | diffstat | ssh foo 'cd xyz && got patch'
