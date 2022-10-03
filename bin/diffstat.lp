# diffstat

Show diff statistics.

	#!/usr/bin/awk -f

maybe not 100% correct, but it's one case where being simple yet
slightly wrong is way easier than correct.  It's not a catastrophe to
count some extra lines, while parsing the diff (possibly enclosed in a
mail) is hard.

	/^\+/ { a++ }
	/^\-/ { m++ }

Don't be a sink!  Continue the pipeline so we can further save or apply
the diff.

	// { print $0 }

At the end, print the stats to standard error to avoid mangling the
input.  Unfortunately, there doesn't seem to be a "built-in" way of
printing to stderr other than using the pseudo-device.

	END {
		print "+", a > "/dev/stderr"
		print "-", m  > "/dev/stderr"
	}

some example usages:

* cvs -q di | diffstat | tee /tmp/diff | less
* git diff | diffstat > /tmp/diff
* got di | diffstat | ssh foo 'cd xyz && got patch'
