# lib

This are some common stuff that needs to be shared between panel
and event-gen.

	fn hc { herbstclient $* }

	if (~ $"monitor '')
		monitor=0

	geometry=`{hc monitor_rect $"monitor}
	if (test -z $"geometry) {
		echo invalid monitor $monitor
		exit 1
	}

	x=$geometry(1)
	y=$geometry(2)
	panel_width=$geometry(3)
	panel_height=16

	font='-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*'

	fn omit-alpha {
		sed 's,^\(\#[0-9a-f]\{6\}\)[0-9a-f]\{2\}$,\1,'
	}

	# extract colors from hlwm and omit alpha-value
	bgcolor=`{hc get frame_border_normal_color | omit-alpha}
	selbg=`{hc get window_border_active_color | omit-alpha}
	selfg='#101010'
