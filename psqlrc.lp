# psqlrc

By default psql renders `NULL' values as empty strings.  This makes it
harder to "see" if a column is `NULL' or an empty string, so I like to
have a different representation for NULLs

	\pset null '⊥'

I also use to connect to databases on different hosts, so to be extra
sure that I'm connected to the right one I'd like for psql to dump the
connection info at the start

	\conninfo
