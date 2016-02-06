---
title: Proper Counter Cache Migrations in Rails
tags: programming
tweet_id:
---

This post is less about the
[basics of `counter_cache` support in Rails](http://guides.rubyonrails.org/association_basics.html#counter-cache)
and more about best practices for introducing a new counter cache to an
existing project. More specifically, the goal is to detail the most efficient
way way to create an ActiveRecord migration to support a new counter cache
column.

## The Problem

You see, the interweb is currently [filled][railscasts] with some
[poor advice](http://blog.obiefernandez.com/content/2011/08/adding-a-counter-cache-to-existing-records.html)
about
[how to seed](http://yerb.net/blog/2014/03/13/three-easy-steps-to-using-counter-caches-in-rails/)
a counter cache column.

[railscasts]: http://railscasts.com/episodes/23-counter-cache-column                                        "Slow"
[obie]:       http://blog.obiefernandez.com/content/2011/08/adding-a-counter-cache-to-existing-records.html "Slow and no batch support"
[yerb]:       http://yerb.net/blog/2014/03/13/three-easy-steps-to-using-counter-caches-in-rails/            "Slow and no migration"

Now that you've clicked on those examples, please erase them from your
memory. Iterating over the entire table, loading each record into ruby-space
(without batching, mind you), and relying on either `update_counters` or
`reset_counters` in your migration is a sure way for your next deployment to
take minutes to finish. It doesn't take millions of records to get hit with
this pain either.

## The Example

Let's assume that we have some stereotypical tables named `posts` and
`comments`. Let's also assume that we decided to add a `comments_count`
counter cache column to the `posts` table.

## The Migration

Given this example, your migration should look something like this:

``` ruby
class AddCommentsCountToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.integer :comments_count, default: 0
    end

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE posts
           SET comments_count = (SELECT count(1)
                                   FROM comments
                                  WHERE comments.post_id = posts.id)
    SQL
  end
end
```

## The Results

With over to 25,000 posts and 100,000 comments, using SQL will take seconds
instead of minutes.

```
-- execute("UPDATE posts SET comments_count = (SELECT count(1) FROM comments WHERE comments.post_id = posts.id)")
   -> 1.3197s
   -> 26900 rows
```

Let's compare that with how long it would have taken if we used a
`Post.reset_counters` approach:

```
-- Seeding posts.comments_count -- Better grab a coffee.
   -> ...........................
   -> 144.7302s
   -> 26900 rows
```

Here is the
[actual code used to run these two examples](https://gist.github.com/rmm5t/5aa63288fc5ab858e718).

## The Moral

_Sometimes SQL can be straightforward and fun._
