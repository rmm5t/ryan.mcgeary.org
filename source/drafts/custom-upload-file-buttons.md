---
title: Custom Upload File Buttons
---
Requires an interesting CSS and HTML hack to get a cross-browser compliant file upload button with style that still pulls up the file dialog without using flash.

the button has the input[type=file] within. The button gets an overflow hidden. The input[type=file] gets a huge font size and right justified. To top it off, it gets an opacity of 0. So when you click the blue button, you'r really clicking the ugly input[type=file]; you just don't know it.

oh, and because the input[type=file] is inside the button, the button still gets an active state allowing it to look depressed on mousedown.

What's the huge font size for?  The huge font size is so the "Browse" button from the input[type=file] takes up all the space on top of the blue button.

You are using [Sass](http://sass-lang.com/) and [Compass](http://compass-style.org/) aren't you?

    a.file
      +dimensions(auto, 29px)
      +fancy-button($base-color)
      display: block
      line-height: 29px
      text-align: center

    // Simulating a file upload button
    a.file
      overflow: hidden
      position: relative
      direction: ltr
      input#preprocess-upload
        position: absolute
        right: 0
        top: 0px
        font-family: Arial
        font-size: 118px
        margin: 0
        padding: 0
        cursor: pointer
        +opacity(0)

Note: Firefox will not give you a pointer cursor no matter what you do.
