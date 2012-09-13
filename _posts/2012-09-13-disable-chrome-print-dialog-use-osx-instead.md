---
layout: post
title: Disable Chrome's Print Dialog and Use the OS X System Dialog Instead
---

I really dislike the custom print dialog that ships with Google Chrome
nowadays (Chrome is currently at v21 at the time of writing). By itself, it's
not terrible, but I want my print dialog to look like every other darn print
dialong on OS X, gosh dammit.

![Google Chrome's Print Dialog](/images/posts/disable-chrome-print-dialog-use-osx-instead/chrome-print-dialog.png "Google Chrome's Print Dialog")

When Google first introduced the new print dialog, Chrome also included a
custom setting to disable it under `about:flags`, but in v20, Chrome removed
the ability to disabled the print dialog.

There are a couple workarounds on the internet like starting Chrome with an
`--args --disable-print-preview`, but that's not too feasible under normal
conditions. Other solutions recommend using `⌘⌥P` or hold down Option (`⌥`) when
accessing the File menu, but who wants to remember to use a different keyboard
shortcut for just one application?

Fortunately, OS X comes with a relatively simple way to override keyboard
shortcuts in specific Applications. Go to System Preferences -> Keyboard ->
Keyboard Shortcuts. Once there, select Application Shortcuts and add a new
shortcut for Google Chrome.

![Override for Chrome's Print Shortcut](/images/posts/disable-chrome-print-dialog-use-osx-instead/chrome-print-shortcut-override.png "Override for Chrome's Print Shortcut")

Make sure the Menu Title reads `Print Using System Dialog...` exactly, and
give it the standard print shortcut (`⌘P`).

![New Chrome Print Shortcuts](/images/posts/disable-chrome-print-dialog-use-osx-instead/chrome-print-shortcuts.png "New Chrome Print Shortcuts")

Enjoy! Happy Printing!

**UPDATE:** There's another workaround that's relatively painless and works
well. Open up Terminal and override the setting at the command line:

    $ defaults write com.google.Chrome DisablePrintPreview -boolean true

This works, but also completely disables the Chrome print dialog altogether,
so there's no way to use it with a different keyboard shortcut in the event
that you wanted to test the default behavior that most users experience.
