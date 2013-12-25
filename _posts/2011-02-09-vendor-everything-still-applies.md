---
layout: post
title: "“Vendor Everything” Still Applies"
---

**UPDATE:** Since writing this post, I have since switched to using
[rbenv](https://github.com/sstephenson/rbenv) for my ruby version management.  I
no longer use RVM. Rbenv lends itself nicely to the workflow described here, and
some of the workflow below has been modified to reflect that. RVM instructions
are still included though.

That's right. The title is a homage to the (now
[_defunkt_](http://twitter.com/defunkt))
[err the blog](http://errtheblog.com/posts/50-vendor-everything), and keeping
your application dependencies with your application is _still_ a very good
thing.

As a consultant, I jump between a lot of different Ruby projects from day to
day.  Some are my own; some are owned by others. Some are greenfield; some are
legacy. Sometimes, I'm the sole developer; sometimes, I'm working with a team.

There's nothing more frustrating than jumping on an existing project only to
fall into dependency hell when your first goal is just a passing test suite.
Dependencies can be quite difficult to manage, and fortunately, we have some
great tools like [Bundler](http://gembundler.com/) and
[rbenv](https://github.com/sstephenson/rbenv) to help out. The problem, however,
is that we as a community have not fully standardized on the best set of
conventions surrounding these tools.

_Disclaimer: The set of conventions described here apply to Ruby applications
only.  This includes Rails apps, Sinatra apps, or other Ruby applications that
aren't deployed in the form of a gem._

## Do Check Your `.ruby-version` into Version Control

> Your `.ruby-version` file is an important piece of documentation.

For applications, your `.rbenv-version` file is an important piece of
documentation.  I think this is the best way to communicate the Ruby version
dependency to other team members. This is especially true given that these
files at the root of your project will make rbenv or RVM automatically use
that version of Ruby when you're in that project directory.

I recently inherited a project that had a test suite with very little coverage
and no documentation as to which version of Ruby was required. I could tell the
project wasn't on Ruby 1.9 yet, so I guessed at Ruby 1.8.7. It wasn't until much
later that I realized Ruby 1.8.6 was actually required.  For another legacy
project that I worked on, we guessed correctly at Ruby 1.8.7, but it wasn't
until we went to deploy and took a look at the production environment that we
realized we should have been developing against Ruby Enterprise Edition (REE)
instead of MRI.

## Stop Using RVM Gemsets For Your Applications

Please stop using RVM gemsets for your applications. Seriously. The original title
of this post was going to be, "RVM Gemsets are overrated," but that seemed too
much like flamebait, and I didn't want anyone to miscontrue my overall point.

RVM is absolutely one of the best things that has hit the Ruby community in
recent history, and [RVM gemsets](http://rvm.beginrescueend.com/gemsets/basics/)
are a great tool. It's just that I see too many applications rely on the use of
gemsets when it yields no added benefit.  I understand why people do it; they
don't want to pollute their default gemset, but this reliance on gemsets for
applications is totally unnecessary.  It also seems to be a common point of
confusion amongst teams.

There is a better way, that still doesn't pollute the default gemset, and it
includes a lesser known feature of Bundler.

## Let Bundler Follow the `--path`

> Bundler alleviates the need for different gemsets per project.

It is possible to install application dependencies cleanly without relying on an
RVM gemset. I like to install all application dependencies into a gitignored
directory within the application itself.  This not only alleviates the need for
different gemsets per project, but it also gives us a quick and easy way to jump
into the source code of any one of our gem dependencies.  We can do this with
the `--path` option passed to
[`bundle install`](http://gembundler.com/bundle_install.html).  Here's the
convention I like to use:

    $ bundle install --path vendor
    $ echo 'vendor/ruby' >> .gitignore

After running this, all gems (and gems pulled directly from git repositories)
will be unpacked into the `vendor/ruby` directory of your project.  It's a good
idea to ignore this directory from version control.

This one step removes the need to create a custom RVM gemset for any of your
applications, and it ensures that your default gemset is never polluted by
application dependencies. This way, Bundler completely isolates the gems from
the system, guaranteeing a clear set of dependencies.

## Package Your Gems in `vendor/cache`

For applications, I cannot emphasize enough how beneficial it is to keep all of
your gem dependencies with your application.  I'm not just talking about a
`Gemfile` and `Gemfile.lock`\*\*, but I'm also talking about the gems
themselves. Bundler allows you to save all of your gems in a `vendor/cache`
directory after running
[`bundle package`](http://gembundler.com/bundle_package.html).  It ensures the
gems are available without having to sync with a gem server.

    $ bundle package

I've seen resistance to this practice, but the only arguments against it usually
refer to taking up too much space in version control. That argument is
poppycock. Storage is cheap. You'll thank me later when your deployments run
smoothly, and when several years from now, an otherwise missing gem is at your
fingertips. Not to mention, having all your gems in `vendor/cache` makes `bundle
install` run faster both for new team members and in your continuous integration
environment. Deployment environments like [Heroku](http://heroku.com/) really
benefit from this practice too.

\*\* By the way, for applications, please do
[check your `Gemfile.lock` into version control](http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/).

## How Can I Remember All of This?

Here are some command line aliases that help me:

    alias b="bundle"
    alias bi="b install --path vendor"
    alias bil="bi --local"
    alias bu="b update"
    alias be="b exec"
    alias binit="bi && b package && echo 'vendor/ruby' >> .gitignore"

Any time I jump into a new project that already has a Gemfile, I merely need to
run `bi` and the gems are installed in an application specific location
(`vendor/ruby`) without the need for a custom RVM gemset.  Anytime I'm starting
a new project or trying to convert an old project to these new conventions, I
just run `binit`, which installs and packages the gems within the application
while also gitignoring the `vendor/ruby` directory.

## TL;DR

* Check your `.ruby-version` file into version control; it's a form of documentation.
* Avoid RVM gemsets for your applications; Bundler solves the same problem in a better way (`bundle install --path vendor`).
* Keep a cache of your gem dependencies in version control using `bundle package`.
* This only applies to Ruby applications; gem development is a different beast.

{% highlight text %}
$ bundle install --path vendor
$ bundle package
$ echo 'vendor/ruby' >> .gitignore
{% endhighlight %}
