# calm window manager

The calm window manager, cwm for short, is my favourite window manager.
It's *the* window manager that convinced me that using a floating window
manager was actually worth it.

My configuration is unusually long.

First I have a list of applications for the built-in menu:

	command emacsclient	"emacsclient -c"
	command firefox		firefox
	command gimp		gimp
	command godot		godot
	command inkscape	inkscape
	command iridium		iridium
	command keepassxc	keepassxc
	command lock		xlock
	command term		myterm

I found these color by random I guess, but they're fine

	color activeborder "#0abeff"
	color inactiveborder "#777"

set a decently-sized border around every window

	borderwidth 2

I've started to use cwm without "sticky" tags.  Enabling the sticky mode
makes cwm behave like other windows managers with "tags" (or
"workspaces".)  Without sticky tags, you can decide with more granularly
which window to show and which not.

	# sticky yes

I also prefer to "snap" windows close to the edges

	snapdist 5

I don't want to give focus to some applications via alt-tab

	ignore sshmenu
	ignore stalonetray
	ignore stats
	ignore termbar
	ignore xclock
	ignore xconsole
	ignore Catclock
	ignore "Speedbar 1.0"

autogroup does what it seems: it automatically moves some windows in a
specific group (aka workspace.)  The group 0 is sticky across all groups

	autogroup 0 XClock
	autogroup 0 Catclock
	autogroup 0 XConsole
	autogroup 0 sshmenu,Xmessage
	autogroup 0 stalonetray
	autogroup 0 stats
	autogroup 0 termbar
	autogroup 2 Firefox
	autogroup 3 Gajim
	autogroup 3 TelegramDesktop

Most cwm keybindings use `alt' which conflicts with emacs.  So I unbind
everything and re-bind most of the keys on the mod4 (super) key

	unbind-key all

	bind-key 4-Tab group-last
	bind-mouse C-3 menu-exec-wm
	bind-key C4-slash menu-window

control the playback

	bind-key XF86AudioPrev "amused prev"
	bind-key XF86AudioNext "amused next"
	bind-key XF86AudioPlay "amused toggle"
	bind-key XF86AudioStop "amused stop"

"gamemode" swiches the keyboard from my custom dvp-eu to an us querty
and vice-versa, and the mouse buttons too.  it's useful when playing
some games, hence the name, or when in need to share the keyboard with
someone else.

	bind-key 4-F5 "gamemode"

I don't have a dedicated key for screenshot on this machine, but
Scroll_Lock is not too awkward to press

	bind-key 4-Scroll_Lock	"sshot -c"
	bind-key 4S-Scroll_Lock	"sshot -cs"

manage the notifications

	bind-key 4-space "pkill -SIGUSR1 xnotify"

basics window movements

	bind-key 4-h window-move-left
	bind-key 4-j window-move-down
	bind-key 4-k window-move-up
	bind-key 4-l window-move-right

	bind-key S4-h window-move-left-big
	bind-key S4-j window-move-down-big
	bind-key S4-k window-move-up-big
	bind-key S4-l window-move-right-big

	bind-key C4-h window-resize-left
	bind-key C4-j window-resize-down
	bind-key C4-k window-resize-up
	bind-key C4-l window-resize-right

	bind-key CS4-h window-resize-left-big
	bind-key CS4-j window-resize-down-big
	bind-key CS4-k window-resize-up-big
	bind-key CS4-l window-resize-right-big

	bind-key 4-greater window-raise
	bind-key 4-less    window-lower

	bind-key 4-Return window-hide
	bind-key C4-x window-close
	bind-key C4-c window-close

	bind-key 4-slash menu

	bind-key CM-Return myterm
	bind-key C4-Return "emacsclient -c"
	bind-key CS4-Return "env SHELL=rc 9term"

	bind-key M-Tab window-cycle
	bind-key MS-Tab window-rcycle

	bind-key 4-f window-maximize
	bind-key C4S-v window-vmaximize
	bind-key C4S-w window-hmaximize

	htile 0
	vtile 0
	bind-key 4-w window-htile
	bind-key 4-v window-vtile

	bind-key C4S-q quit

I'm using a custom keyboard layout based on the dvorak-programmer.
Thus, the upper row is not numbers, but symbols!

	# & { [ ( = + ) ] }
	bind-key 4-ampersand            group-toggle-1
	bind-key 4-braceleft            group-toggle-2
	bind-key 4-bracketleft          group-toggle-3
	bind-key 4-parenleft            group-toggle-4
	bind-key 4-equal                group-toggle-5
	bind-key 4-plus                 group-toggle-6
	bind-key 4-parenright           group-toggle-7
	bind-key 4-bracketright         group-toggle-8
	bind-key 4-braceright           group-toggle-9

move with shift

	bind-key S4-ampersand           window-movetogroup-1
	bind-key S4-braceleft           window-movetogroup-2
	bind-key S4-bracketleft         window-movetogroup-3
	bind-key S4-parenleft           window-movetogroup-4
	bind-key S4-equal               window-movetogroup-5
	bind-key S4-plus                window-movetogroup-6
	bind-key S4-parenright          window-movetogroup-7
	bind-key S4-bracketright        window-movetogroup-8
	bind-key S4-braceright          window-movetogroup-9
	bind-key S4-exclam              window-movetogroup-0

mouse bindings

	bind-mouse 4-1  window-move
	bind-mouse 4-3  window-resize
