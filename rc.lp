# rc -- run commands

Althought it's not my interactive shell, I do like plan9' rc.  (well,
the first version was for UNIX if I recall correctly, but...)

My configuration is pretty small, just tweak the prompt

	prompt=('% ' '')

make sure $user and $home are defined

	user=$USER
	home=$HOME

and some aliases

	fn git { env git --no-pager $* }
	fn m { make $* }

oh, and make the prompt executable!

	fn % { $* }
