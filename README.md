
# Various window management fixes for the Linux Steam client

**DISCLAIMER: Use at your own risk! This is in no way endorsed by VALVE.**

Forked from [GitHub](https://github.com/dscharrer/steamwm)

Feature request for these changes to be implemented in Steam: 
[issue #1040](https://github.com/ValveSoftware/steam-for-linux/issues/1040)

## steamwm.cpp

The window management fixes:

* Force borders on non-menu windows.
* Let the WM position non-menu/tooltip windows.
* Group all steam windows.
  This helps WMs with their focus stealing preventions,
  and also prevents all Steam windows from being dimmed
  (by KWin) if any Steam window has focus (is a KWin setting).
* Tell the WM which Steam windows are dialogs.
  This lets the window manager place them more intelligently.
  For example, the WM might center dialogs.
* Steam sets error dialogs as unmanaged windows - fix that.


Obsolete fixes (now disabled by default):

* Set `_NET_WM_NAME` to the `WM_NAME` value to get better window titles.
* Set fixed size hints for windows with a fixed layout.

Fixes can be individually enabled or disabled - for details see the 
comments in the source file.

This file compiles to a library that can be `LD_PRELOAD`ed into the 
Steam process. For your convenience there's also a wrapper-script
supplied.

Requires: `g++` with support for x86 targets, `Xlib` + headers

Use:

    $ make 
    $ export LD_PRELOAD="steamwm.so:${LD_PRELOAD}"
    $ export LD_LIBRARY_PATH="lib32:lib64:${LD_LIBRARY_PATH}"
    $ steam

Or copy around lib32 and lib64 to ~/lib and use the supplied 
steam.sh script:

    $ make 
    $ make install
    $ bin/steam.sh

## noframe.patch

This is a Steam skin that complements `steamwm.cpp`: It is exactly the same as the default skin, but with the window borders and controls removed.

To install it use:

    $ chmod +x noframe.patch
    $ ./noframe.patch

and then select the `noframe` skin in the Steam settings.
