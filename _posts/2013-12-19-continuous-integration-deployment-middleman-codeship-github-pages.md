---
layout: post
title: "Continuous Integration and Deployment with Middleman, Codeship, and GitHub Pages"
---
I use [GitHub Pages](http://pages.github.com/) for hosting some of my
websites, and I use the [Middleman](http://middlemanapp.com/) static site
generator as my content management system for some of these sites.

I like to run continuous integration for my projects whenever possible, and
this goes for static site repositories as much as regular code repositories.

Recently, I started playing with
[Codeship](https://www.codeship.io/?referral_token=suhjnfd0sdye885fstjjsfyo0). It's
a well-priced continuous integration and deployment service, and I wanted to
be able to automatically deploy my middleman site upon successful builds to
the master branch. It took a bit of trial and error, but I finally got
something that works well.

## Test Settings

After initializing a new GitHub repository in Codeship, you'll need to define
how tests are run. Under the _Test_ project settings in Codeship, select
_Ruby_ as the language and define your _Setup Commands_ and _Test Commands_.

### Setup Commands:

    bundle install

### Test Commands:

    bundle exec middleman build

Perfect. Now your site will run a test build upon every code push.

## Deployment Settings

This is where I had some trouble, but I finally found a set of commands that
correctly deloyed to our `gh-pages` branch in the repository. First, it's
worth mentioning that I use the
[middleman-gh-pages](https://github.com/neo/middleman-gh-pages) gem for
deploying to the `gh-pages` branch. This gem gives you a `rake publish` task
that handles most of the dirty work.

Under the _Deployment_ project settings in Codeship, configure a deployment
from the master branch using a _Custom Script_.

### Custom Script:

    git config --global user.email "robot@example.com"
    git config --global user.name "Codeship Robot"
    rm -rf build
    git remote set-branches --add origin gh-pages
    git fetch
    bundle exec rake publish
    sleep 30
    wget --retry-connrefused --no-check-certificate -T 60 http://yoursite.com/

This configures a git user, removes the `build` directory that was left there
from the test steps, adds a `gh-pages` remote branch (because Codeship only
clones the relevant branch during setup), and runs the `rake publish` task to
deploy the site to the `gh-pages` branch.

If all went well, your site will automatically deploy to GitHub Pages upon a
push and successful build in the master branch.

**Note:** Make sure the email address that you use for this git user is a
verified email address in your GitHub account. Otherwise, GitHub will accept
the commit, but it will not get published to your site. To fully make
everything work, you will need to do one of two things. 1. Move the Codeship
deploy key to an SSH key in your own GitHub account (not recommended) OR 2)
Create a new machine user on GitHub and move the Codeship deploy key to an SSH
key on that user account, give that machine user push/pull access to the
repository, and make sure that machine user's email address is fully verified
by GitHub..

## Extra Credit: Force Codeship to skip builds on the gh-pages branch.

Unfortunately, Codeship currently tries to run builds on all branches,
including the `gh-pages` branch. This is undesirable for this setup, so to
avoid this, we also need to add "--skip-ci" or "\[skip ci\]" to the commit
message that is pushed to the gh-pages branch.

Fortunately, after
[this pull-request](https://github.com/neo/middleman-gh-pages/pull/16) by
yours truly, middleman-gh-pages can support that.

If using version >= 0.0.3 (or the master branch), you can add this to the
bottom of your project's Rakefile:

    # Ensure builds are skipped when pushing to the gh-pages branch
    ENV["COMMIT_MESSAGE_SUFFIX"] = "[skip ci]"
