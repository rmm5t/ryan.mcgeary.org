# Getting started

This site utilizes [jekyll](https://github.com/mojombo/jekyll) and
[compass](https://github.com/chriseppstein/compass) heavily.

    $ bundle install --path vendor

Code samples also rely on Pygments, so make sure that is installed.  Here's how
I do it on OS X, but there's more info on the
[jekyll wiki](https://github.com/mojombo/jekyll/wiki/install).

    $ brew install python
    $ pip install --upgrade distribute
    $ pip install --upgrade distribute
    $ pip install --upgrade pip
    $ pip install pygments

_Note: Immediately after installing python, be sure to add `/usr/local/share/python` to the `PATH`_

    export PATH="/usr/local/Cellar/python:${PATH}"

# Development

    $ rake watch     # also the default task

This will build the site and automatically watch for file changes using
[FSSM](https://github.com/ttilley/fssm).  This also attempts to open the root of
the site in your browser, but expects a virtual host to exist for local
development.  See the Rakefile for specifics.

# Building once

    $ rake build

# Publishing

    $ rake publish

This assumes you have the proper ssh credentials, including the correct username
in your `~/.ssh/config`.
