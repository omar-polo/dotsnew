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
	command term		xterm
	command xterm.jp	xterm.jp

I found these color by random I guess, but they're fine

	color activeborder "#0abeff"
	color inactiveborder "#777"

set a decently-sized border around every window

	borderwidth 2

I don't understand how cwm is meant to be used by deafult since I'm used
to window managers with "tags" (or "workspaces").  Fortunately I can
enable "sticky" mode on cwm to simulate workspaces

	sticky yes

I also prefer to "snap" windows close to the edges

	snapdist 5

with cwm I usually use tint2 as bar, either at the top or at the bottom.
cwm doesn't account the space for it automatically like other window
manager, we have to do that manually

	gap 0 30 0 0

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
	
eat up multimedia keys so they don't get seen by some programs (like
emacs or sam)

	bind-key XF86AudioLowerVolume true
	bind-key XF86AudioRaiseVolume true

control the playback

	bind-key XF86AudioPrev "amused prev"
	bind-key XF86AudioNext "amused next"
	bind-key XF86AudioPlay "amused toggle"

I don't have a dedicated key for screenshot on this machine, but
Scroll_Lock is not too awkward to press

	bind-key 4-Scroll_Lock	"sshot -c"
	bind-key 4S-Scroll_Lock	"sshot -cs"

manage the notifications

	bind-key 4-space "dunstctl close"
	bind-key 4S-space "dunstctl history-pop"
	bind-key 4-n "dunstctl context"

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
	bind-key 4-at jgmenu_run

	bind-key CM-Return xterm # kitty
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
	bind-key 4-ampersand            group-only-1
	bind-key 4-braceleft            group-only-2
	bind-key 4-bracketleft          group-only-3
	bind-key 4-parenleft            group-only-4
	bind-key 4-equal                group-only-5
	bind-key 4-plus                 group-only-6
	bind-key 4-parenright           group-only-7
	bind-key 4-bracketright         group-only-8
	bind-key 4-braceright           group-only-9

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

use ctrl to toggle visibility

	bind-key C4-ampersand            group-toggle-1
	bind-key C4-braceleft            group-toggle-2
	bind-key C4-bracketleft          group-toggle-3
	bind-key C4-parenleft            group-toggle-4
	bind-key C4-equal                group-toggle-5
	bind-key C4-plus                 group-toggle-6
	bind-key C4-parenright           group-toggle-7
	bind-key C4-bracketright         group-toggle-8
	bind-key C4-braceright           group-toggle-9

mouse bindings

	bind-mouse 4-1  window-move
	bind-mouse 4-3  window-resize
