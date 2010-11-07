---
title: RVM Gemsets Are Overrated
---
_vender everything still applies_
referencing the now _defunkt_ [err the blog](http://errtheblog.com/posts/50-vendor-everything)

* As a consultant, I jump between a lot of different projects from day to day.
** Some are my own
** Some are others
** Sometimes I'm the sole developer
** Sometimes I'm working with a team

* Dependencies can be quite difficult to manage
** Most people handle this with a combination of bundler and rvm gemsets
** ...gemsets are overrated...
** Bundler can handle it all (too bad these aren't the defaults)

https://gist.github.com/622202#gistcomment-11626

> Off topic, but for projects, I don't find gemsets to be of much use. Every
> project should have a Gemfile and install the project gems in a .gitignore'd
> directory. I really don't like the default behavior that bundle install has
> such that it installs gems to the current gem path. I like my project's gems
> to be installed under a gitignored vendor directory.

    $ bundle install --path vendor
    $ bundle package
    $ echo 'vendor/ruby' >> .gitignore

> All my project's gems are kept with the project itself (because of --path
> vendor), everyone has access to the cache (because of bundle package), and
> gemsets are barely needed.
