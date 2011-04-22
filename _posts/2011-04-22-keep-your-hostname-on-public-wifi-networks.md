---
layout: post
title: Keep Your Hostname on Public WiFi Networks
---

Have you ever joined a public WiFi network only to have your hostname change to
something seemingly random?  While hacking with
[Wayne Seguin](http://twitter.com/wayneeseguin) last night on a hotel network,
he ran into this exact problem on OS X, and it reminded me of a workaround that
I learned about a few years ago.

Some networks have their DHCP server configured to assign hostnames for all
machines that connect to it. OS X respects this and will reassign your hostname
automatically. I suspect this is to help avoid name collisions on the network,
but if you want to prevent OS X from doing this, there is a workaround.

Open `/etc/hostconfig` and add the following line:

    HOSTNAME=<your-preferred-hostname>.local

Afterwards, OS X will no longer respect the DHCP command to reassign the
hostname.  This is especially helpful if you have scripts that rely on your
hostname being set to something specific.

