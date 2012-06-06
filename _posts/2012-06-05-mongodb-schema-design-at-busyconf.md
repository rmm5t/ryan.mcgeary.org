---
layout: post
title: MongoDB Schema Design at BusyConf
---

This post is in response to the
[10gen MongoDB Schema Design Contest](http://blog.10gen.com/post/23237721457/blogging-contest-mongodb-schema-design). It
was also extracted from
[talks](http://ryan.mcgeary.org/talks/2010/12/14/busyconf-mongodc/) that I've
given on the subject.

## Obligatory Plug

[BusyConf][busyconf] currently handles 4 major pieces of conference planning --
it collects speaker proposals, allows the review committee to rate speaker
proposals, builds an offline-enabled and archived HTML5 schedule (iPhone,
Android, iPad, Desktop), and handles attendee ticket registration including
payments, refunds, etc.

We attend conferences, and as attendees, the schedule at the conference is often
lacking.  It's poorly organized, lacks information, and requires Internet
access. This makes it hard as an attendee to choose the talks that you want to go
to. [BusyConf][busyconf] is an attempt to solve that problem while also making
it easier for conference organizers to run a conference.  We handle the calls
for proposal, we allow organizers to rate proposals, we give them an interface
to turn activities into a schedule, and we publish that schedule in many
formats. We also handle ticket registration and credit card payments.

## Why MongoDB?

[MongoDB][mongodb] was a huge win for us while designing our application. The
goal of this post is to explain why we chose MongoDB, how we use it at Busyconf,
what design decisions we considered, and what the alternatives might have been.

Here's a common myth that I've heard before: _"MongoDB design is easy because
its schema-less."_ I disagree with this. It's true that a thoughtful design will
yield a longer term gain in easier development, but it can be tricky to conjure
up with such a design. I find it much easier to get a relational design right
the first time, but the costs of maintaining a relational design can sometimes
be higher.

> "You could use a relational database for that! Why use a document store?"

MongoDB's speed and scalability are wins, but for us, it’s not as important as
the win we get from rapid development. Rapid development comes from the ability
to represent richer data models that more closely match the business problems
and the patterns of access.

Many people say things like: _"You could use a relational database for that! Why
use a document store?"_  MongoDB has become our default database for greenfield
development. We now make ourselves justify the use of relational. Instead of,
_"Why MongoDB?"_ we ask, **_"Why NOT MongoDB?"_**

## The Logical Model

This post only covers the design of our database that represents a conference
schedule.  The data model that represents a conference schedule is a roughly
tree -- very nested. Imagine a typical conference or convention that you
attended in the past. Events have days, days have tracks, tracks have time
slots, time slots have activities, and activities have speakers. In addition,
days can also have global time slots (like Lunches, Breaks, and Keynotes).

![BusyConf Logical Model](/images/posts/mongodb-schema-design-at-busyconf/logical-model.png "BusyConf Logical Model")

When we access our data for rendering a schedule, we need to pull all of this at
once, because we want a seamless, cached experience for the conference attendee.

## The Relational Option

What might the above logical model look like in a relational database?  The nice
thing about a relational model is that they are fairly easy to design.  This is
how we might have modeled our data given a relational database.

![BusyConf Relational Model](/images/posts/mongodb-schema-design-at-busyconf/relational-model.png "BusyConf Relational Model")

> What kind of queries would be required to pull all the data from this design?

It looks pretty straight forward until you imagine having to pull all this data
at once to render a full schedule. What kind of query or queries would be
required from a relational database? Would you use one big nasty join, or lots
of individual queries? Neither seem like a great option.

To add to the problem, little things like the position of tracks are not easily
represented.  Neither is the potential explosion of meta data that could come
from each object.

## First Attempt with MongoDB

Representing our logical model directly within MongoDB was our first instinct,
BUT putting this into practice actually led us down a road of unnecessary
complexities:

![BusyConf MongoDB Model - First Attempt](/images/posts/mongodb-schema-design-at-busyconf/mongodb-option1.png "BusyConf MongoDB Model - First Attempt")

> This first attempt was a mistake.

While we solved the problem of quickly accessing the entire event, we no longer
have an easy way of accessing an individual activity or speaker.  We can quickly
see the complexities in the drawing above.

## Current Design with MongoDB

We iterated on the design many times, but in the end, we took a fairly unique
approach.

![BusyConf MongoDB Model - Current Design](/images/posts/mongodb-schema-design-at-busyconf/mongodb-option2.png "BusyConf MongoDB Model - Current Design")

Instead of one collection, we broke out Activities and Speakers.[^1] This
matched our patterns of access much better. Instead of deeply nesting every
object, we chose to embed arrays of days, tracks, and time slots immediately
under the event document.

Each object has a unique ID. Everything is more easily addressable, because we
have less nesting. The logical model is represented with pointers from one
nested document to another. Of course, we don't actually see our logical model
until we piece it together on the client side, but that is okay because we don't
need the full logical model until until we put the leg work in to render the
schedules in the browser.

## Conclusion

MongoDB can be somewhat tricky when it comes to the up front design, but if done
right, it has some great benefits both in defining and matching your unique
access patterns along with fairly decent long-term maintenance benefits.

[^1]: Later, we decided to embed Speakers under Activities to improve our
patterns of access, but ironically, we plan to switch Speakers back out to their
own collection again to provide cleaner normalization.

[busyconf]: http://busyconf.com/
[mongodb]: http://www.mongodb.org/
