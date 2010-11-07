# Getting started

This site utilizes [jekyll](https://github.com/mojombo/jekyll) and
[compass](https://github.com/chriseppstein/compass) heavily.

    $ bundle install --path vendor

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
