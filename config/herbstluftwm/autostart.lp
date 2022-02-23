# herbstluftwm

herbstluftwm is a window manager.  The following is my configuration,
which is based on the default one (with tweaks to avoid depending on
bash)

	#!/bin/sh

herbstclient is quite long to write, so abbreviate it

	alias hc=herbstclient

	hc emit_hook reload

remove all existing keybindings before adding the new ones

	hc keyunbind --all

I prefer using mod4 (the super/windows/... key) to manage the window
manger, with only few exceptions

	#Mod=Mod1   # Use alt as the main modifier
	Mod=Mod4    # Use the super key as the main modifier

	hc keybind $Mod-Tab use_previous
	hc keybind $Mod-Shift-q quit
	hc keybind $Mod-Shift-r reload
	hc keybind $Mod-Shift-c close
	hc keybind $Mod-slash spawn menu
	hc keybind $Mod-Control-Return spawn emacsclient -c
	hc keybind Control-Mod1-Return spawn xterm

control amused (my music player)

	hc keybind XF86AudioNext spawn amused next
	hc keybind XF86AudioPlay spawn amused toggle
	hc keybind XF86AudioPrev spawn amused prev
	hc keybind XF86AudioStop spawn amused stop

I don't have a dedicated key for screenshot, but Scroll_Lock is not too
awkward to press

	hc keybind $Mod-Scroll_Lock spawn sshot -c
	hc keybind $Mod-Shift-Scroll_Lock spawn sshot -cs

basic movement in tiling and floating mode focusing clients

	hc keybind $Mod-Left  focus left
	hc keybind $Mod-Down  focus down
	hc keybind $Mod-Up    focus up
	hc keybind $Mod-Right focus right
	hc keybind $Mod-h     focus left
	hc keybind $Mod-j     focus down
	hc keybind $Mod-k     focus up
	hc keybind $Mod-l     focus right

moving clients in tiling and floating mode

	hc keybind $Mod-Shift-Left  shift left
	hc keybind $Mod-Shift-Down  shift down
	hc keybind $Mod-Shift-Up    shift up
	hc keybind $Mod-Shift-Right shift right
	hc keybind $Mod-Shift-h     shift left
	hc keybind $Mod-Shift-j     shift down
	hc keybind $Mod-Shift-k     shift up
	hc keybind $Mod-Shift-l     shift right

splitting frames creates an empty frame at the specified direction

	hc keybind $Mod-u       split   bottom  0.5
	hc keybind $Mod-o       split   right   0.5

let the current frame explode into subframes

	hc keybind $Mod-Control-space split explode

resizing frames and floating clients

	resizestep=0.02
	hc keybind $Mod-Control-h       resize left +$resizestep
	hc keybind $Mod-Control-j       resize down +$resizestep
	hc keybind $Mod-Control-k       resize up +$resizestep
	hc keybind $Mod-Control-l       resize right +$resizestep
	hc keybind $Mod-Control-Left    resize left +$resizestep
	hc keybind $Mod-Control-Down    resize down +$resizestep
	hc keybind $Mod-Control-Up      resize up +$resizestep
	hc keybind $Mod-Control-Right   resize right +$resizestep

add the tags

	hc rename default "1" || true
	addtag() {
		hc add $1
		if [ ! -z "$2" ]; then
			hc keybind "$Mod-$2" use $1
			hc keybind "$Mod-Shift-$2" move $1
		fi
	}

	addtag 1 ampersand
	addtag 2 braceleft
	addtag 3 bracketleft
	addtag 4 parenleft
	addtag 5 equal
	addtag 6 plus
	addtag 7 parenright
	addtag 8 bracketright
	addtag 9 braceright
	addtag 0 exclam

cycle through tags

	hc keybind $Mod-period use_index +1 --skip-visible
	hc keybind $Mod-comma  use_index -1 --skip-visible

manage the layout

	hc keybind $Mod-r remove
	hc keybind $Mod-s floating toggle
	hc keybind $Mod-f fullscreen toggle
	hc keybind $Mod-Shift-f set_attr clients.focus.floating toggle
	hc keybind $Mod-Shift-m set_attr clients.focus.minimized true
	hc keybind $Mod-Control-m jumpto last-minimized
	hc keybind $Mod-p pseudotile toggle

I prefer for the default layout to be `max' (only one window visible)

	hc set default_frame_layout max

The following cycles through the available layouts within a frame, but
skips layouts, if the layout change wouldn't affect the actual window
positions.  I.e. if there are two windows within a frame, the grid
layout is skipped.

	hc keybind $Mod-space						\
		or , and . compare tags.focus.curframe_wcount = 2	\
			. cycle_layout +1				\
				vertical horizontal max vertical grid	\
			, cycle_layout +1

mouse bindings

	hc mouseunbind --all
	hc mousebind $Mod-Button1 move
	hc mousebind $Mod-Button2 zoom
	hc mousebind $Mod-Button3 resize

focus
	hc keybind Mod1-Tab         cycle_all +1
	hc keybind Mod1-Shift-Tab   cycle_all -1

	hc keybind $Mod-BackSpace   cycle_monitor
	hc keybind $Mod-c cycle
	hc keybind $Mod-i jumpto urgent

theme

	hc attr theme.tiling.reset 1
	hc attr theme.floating.reset 1
	hc set frame_border_active_color '#222222cc'
	hc set frame_border_normal_color '#ffffff'
	hc set frame_bg_normal_color '#565656aa'
	hc set frame_bg_active_color '#345F0Caa'
	hc set frame_border_width 1
	hc set always_show_frame on
	hc set frame_bg_transparent on
	hc set frame_transparent_width 5
	hc set frame_gap 4

	hc attr theme.title_height 0
	#hc attr theme.title_font 'Dejavu Sans:pixelsize=12'  # example using Xft
	hc attr theme.title_font '-*-fixed-medium-r-*-*-13-*-*-*-*-*-*-*'
	hc attr theme.padding_top 2  # space below the title's baseline (i.e. text depth)
	hc attr theme.active.color '#9AFAFF'
	hc attr theme.title_color '#222222'
	hc attr theme.normal.color '#ffffef'
	hc attr theme.urgent.color '#7811A1dd'
	hc attr theme.normal.title_color '#898989'
	hc attr theme.inner_width 1
	hc attr theme.inner_color black
	hc attr theme.border_width 2
	hc attr theme.floating.border_width 4
	hc attr theme.floating.outer_width 1
	hc attr theme.floating.outer_color black
	hc attr theme.active.inner_color '#789161'
	hc attr theme.urgent.inner_color '#9A65B0'
	hc attr theme.normal.inner_color '#606060'
	# copy inner color to outer_color
	for state in active urgent normal ; do
		hc substitute C theme.${state}.inner_color \
			attr theme.${state}.outer_color C
	done
	hc attr theme.active.outer_width 1
	hc attr theme.background_color '#141414'

	hc set window_gap 0
	hc set frame_padding 0
	hc set smart_window_surroundings off
	hc set smart_frame_surroundings on
	hc set mouse_recenter_gap 0

	hc set focus_follows_mouse 1
	hc set raise_on_click false
	hc set snap_gap 5

rules

	hc unrule -F
	#hc rule class=XTerm tag=3 # move all xterms to tag 3
	hc rule focus=on # normally focus new clients
	hc rule floatplacement=smart
	#hc rule focus=off # normally do not focus new clients
	# give focus to most common terminals
	#hc rule class~'(.*[Rr]xvt.*|.*[Tt]erm|Konsole)' focus=on
	hc rule windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' floating=on
	hc rule windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on
	hc rule windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off

	hc set tree_style '╾│ ├└╼─┐'

A cool thing about herbstluftwm is that I can "dump" the layout and
later reload it:

	load_layout() {
		if [ -f "$2" ]; then
			hc load $1 "$(cat $2)"
		fi
	}

	load_layout 2 ~/herbst.ws.2
	load_layout 3 ~/herbst.ws.3

unlock, just to be sure

	hc unlock

I'd like to have some gaps around my only monitor, herbstluftwm makes it
incredibly easy

	herbstclient set_monitors $((1920-100))x$((1080-100))+50+50
	# hc detect_monitors

Finally launche the panel on each screen.  I rewrote the original
script for the monitor in a mix of rc (the plan9 shell) and awk.

	cd ~/.config/herbstluftwm
	for monitor in $(hc list_monitors | cut -d: -f1) ; do
		./panel "$monitor" &
	done
