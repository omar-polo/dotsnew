# panel

This is the scripts that creates the bar in my herbstluftwm setup.
It's written in rc (the plan9 shell) because why not.

	#!/usr/bin/env rc

	monitor=$1

	. ./lib

	hc pad $monitor $panel_height

	fn process {
		awk -f process.awk \
			-v selbg=$"selbg \
			-v selfg=$"selfg \
			-v font=$"font \
			-v monitor=$"monitor
	}

	fn render {
		dzen2 -w $panel_width -x $x -y $y -h $panel_height \
			-fn $"font -ta l -bg $"bgcolor -fg '#222222'
	}

	./event-gen $"monitor | process | render >[2] /dev/null
