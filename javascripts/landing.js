(function($) {
  $(document).ready(function() {
    $("#github_bubble blockquote").simpleCycle(5500);
    $("#twitter_bubble blockquote").simpleCycle(7000);
  });
})(jQuery);

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
})(jQuery);
