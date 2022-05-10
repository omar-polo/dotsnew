# gmi2txt

gmi2txt is a small script to format a text/gemini page.  needs par(1)

	#!/usr/bin/awk -f
	
	BEGIN {
		in_pre = 0
	
		title1 = "sed s/./=/g"
		title2 = "sed s/./-/g"
		parl = "par 72p2"
		pari = "par 72p3 | sed '2,$s/^ \\*/  /'"
		parq = "par 72p2"
		par = "par 72"
	}
	
	!in_pre && /^```/ {
		in_pre = 1
		print $0
		next
	}
	in_pre && /^```/ {
		in_pre = 0
		print $0
		next
	}
	in_pre { print $0; next }
	
	// {
		# print a blank line between links and other line
		# types, unless there's already a blank line.
	
		if (last_was_link && !match($0, "^[ \t]*$")) {
			print "";
		}
	}
	
	/^=>/ {
		last_was_link = 1
	
		$0 = gensub("=> *", "", 1)
		link = $1
		$1 = ""
		text = gensub("^ *", "", 1)
		if (text == "")
			text = link
	
		printf("~ %s\n", text) | parl
		printf("%s\n", link)
		close(parl)
		next
	}
	
	// { last_was_link = 0 }
	
	/^###/ {
		t = gensub("### *", "", "1")
		printf("-%s-\n", t)
		next
	}
	
	/^##/ {
		t = gensub("## *", "", 1)
		print t
		print t | title2
		close(title2)
		next
	}
	
	/^#/ {
		t = gensub("# *", "", 1)
		print t
		print t | title1
		close(title1)
		next
	}
	
	/^>/ {
		print $0 | parq
		close(parq)
		next
	}
	
	/^\*/ {
		printf(" %s", $0) | pari
		close(pari)
		next
	}
	
	// {
		print $0 | par
		close(par)
	}
	
	END {
		if (in_pre)
			print "```"
	}
	
