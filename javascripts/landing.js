(function($) {
  $(document).ready(function() {
    $("#twitter_bubble .main_bubble").appendTwitterQuotes("rmm5t", "mcgearygroup", function() {
      $("#twitter_bubble blockquote").simpleCycle(7000);
    });
    $("#github_bubble .main_bubble").appendGithubPushes("rmm5t", function() {
      $("#github_bubble blockquote").simpleCycle(5500);
    });
  });

  $.fn.appendTwitterQuotes = function(screen_name, filtered_by_screen_name, callback) {
    return this.each(function() {
      var container = $(this);
      var params = { screen_name: screen_name, count: 20, include_rts: true };
      $.getJSON("http://api.twitter.com/1/statuses/user_timeline.json?callback=?", params, function(data) {
                  
        $.each(data, function(i, status) { 
          if (status.text.indexOf("@") === 0) { return; } // Skip replies
          var blockquote = $('<blockquote></blockquote>');
          var message = $('<div class="message"></div>').text(status.text).autolink();
          var time = $('<div class="info"></div>').text(status.created_at);
          container.append(blockquote.append(message).append(time));
        });
        container.find(".loading").remove();
        if (callback) { callback(); }
      });
    });
  };

  $.fn.autolink = function () {
    return this.each( function(){
      var link    = /((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g;
      var twitter = /@([a-zA-Z0-9_]+)/g;
      var text = $(this).text();
      text = text.replace(link,    '<a href="$1">$1</a>');
      text = text.replace(twitter, '@<a href="http://twitter.com/$1">$1</a>');
      $(this).html(text);
    });
  };

  $.fn.appendGithubPushes = function(username, callback) {
    return this.each(function() {
      var container = $(this);
      $.getJSON("https://github.com/" + username + ".json?callback=?", function(data) {
        var count = 0;
        $.each(data, function(i, event) { 
          if ((event.type != "PushEvent") || (count >= 8)) { return; }
          count++;
          var payload = event.payload;
          var refs = payload.ref.split("/");
          var branch = refs[refs.length - 1];
          var repo = payload.repo;
          var text = "pushed to " + branch + " at ";
          var repoLink = $("<a></a>").attr("href", event.repository.url).text(repo);

          var blockquote = $('<blockquote></blockquote>');
          var message = $('<div class="message"></div>').text(text).append(repoLink);
          blockquote.append(message);

          $.each(payload.shas, function(i, sha) { 
            if (i > 4) { return; }
            var commit = (i < 4) ? sha[2].split("\n", 1)[0] : "...";
            var info = $('<div class="info"></div>').text(commit);
            blockquote.append(info);
          });

          var timeLink = $("<a></a>").attr("href", event.url).text(event.created_at);
          var time = $('<div class="info"></div>').append(timeLink);
          container.append(blockquote.append(time));
        });
        container.find(".loading").remove();
        if (callback) { callback(); }
      });
    });
  };
}(jQuery));


/*
 * Inspired by the jQuery Cycle and the Quovolver plugins:
 *   http://jquery.malsup.com/cycle/
 *   http://sandbox.sebnitu.com/jquery/quovolver/
 *
 * Licensed under the MIT:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright (c) 2010, Ryan McGeary (ryanonjavascript -[at]- mcgeary [*dot*] org)
 */
(function($) {
  $.fn.simpleCycle = function(delay, speed) {
    delay = delay || 6000;
    speed = speed || 500;
    var interval = delay + (3 * speed);

    var slides = this;
    var slideCount = slides.size();
    var index = 0;
    var timeout = null;

    if (slideCount == 0) return this;

    slides.wrapAll("<div class='simpleCycle_wrapper'></div>");
    var wrapper = slides.parent();

    var currentSlide = function() { return $(slides.get(index)); };
    var nextSlide = function() { return $(slides.get(nextIndex())); };
    var nextIndex = function() { return (index + 1) % slideCount; };
    var bump      = function() {
      if (animating) return;
      animating = true;
      currentSlide().fadeOut(speed, function() {
        wrapper.animate({ height: nextSlide().height() }, speed, function() {
          nextSlide().fadeIn(speed);
          index = nextIndex();
          animating = false;
        }); 
      });
    };

    var paused    = true;
    var animating = false;
    var pause  = function() { paused = true;  };
    var play   = function() { paused = false; };

    var cycle = function(force) {
      if (force || !paused) { bump(); }
      return timeout = setTimeout(function() { cycle(false); }, interval);
    };

    var advance = function() {
      if (timeout) timeout = clearTimeout(timeout);
      cycle(true);
    };

    slides.hide();
    currentSlide().show();
    wrapper.css("height", currentSlide().height());

    wrapper.click(advance);
    wrapper.hover(pause, play);

    cycle() && play();

    return this;
  };
}(jQuery));


// protection against accidental left-over console.log statements
if (typeof console === "undefined" || console === null) {
  console = { log: function() { } };
}
