# Space Frame
---

![Space Frame](http://i.imgur.com/W9sXrgK.gif)

Space Frame allows you to use up to 4 images to transition between using a scrubber.  You can use 2 images and restrict movement to just horizontal or vertical as well.

## Dependencies

* [jQuery](http://jquery.com) version 1.8.0 or greater
  * _jQuery 2.0 does not support IE6/7/8_
* [jQuery UI: Draggable](http://jqueryui.com/draggable/)

## Getting Started
Download the [JS][max]
Download the [CSS][css]

[max]: https://raw.github.com/brewster1134/jquery-space-frame/master/dist/spaceFrame.js
[css]: https://raw.github.com/brewster1134/jquery-space-frame/master/dist/spaceFrame.css

#### HTML

To use a 2 panel space frame, add a `x` or `y` class to the `space-frame`
element.  `x` will create a left/right space frame on the x axis, and `y` will
create a top/bottom space frame on the y axis.

Panels are not only restricted to images.  Any content can be used *however* the
space frame is sized based on the computed width/height of the largest panel.
Being explicit with the sizing of content will present more desirable results :)

#### JS

When initializing the space frame `$(window).load()` is preferred over
`$(document).ready()`.  If the panels contain images, the panels may be
incorrectly sized before the images are loaded.  This problem was noticed with
WebKit computing width/height of the various panels.

## Examples

#### HTML (shown in HAML)

``` haml
%h1 4 Panel
.space-frame#four_panel
  .space-scrubber
  .space-panel
    %img{ src: 'kitty.jpg'}
  .space-panel
    %img{ src: 'kitty_red.jpg'}
  .space-panel
    %img{ src: 'kitty_green.jpg'}
  .space-panel
    %img{ src: 'kitty_blue.jpg'}

%h1 2 Panel Left/Right
.space-frame.x#two_panel_left_right
  .space-scrubber
  .space-panel
    %img{ src: 'kitty_red.jpg'}
  .space-panel
    %img{ src: 'kitty_blue.jpg'}

%h1 2 Panel Top/Bottom
.space-frame.y#two_panel_top_bottom
  .space-scrubber
  .space-panel
    %img{ src: 'kitty_green.jpg'}
  .space-panel
    %img{ src: 'kitty_blue.jpg'}
```

#### JS (shown in CoffeeScript)

Initialize the spaceframe

``` coffee-script
(($) ->
  $(window).load ->
    $('.space-frame').SpaceFrame()
) jQuery
```

#### Demo

A full working demo is available at `demo/index.html`

## Development

### Dependencies

* [CoffeeScript](http://coffeescript.org)
* [SASS](http://sass-lang.com/)

Do **NOT** modify any files in the `dist` directory!  Modify the files in the `src` directory and compile them into the dist directory.

This will be done automatically if you are running the tests with testem _(see the [Testing](#testing) section below)_, or you can compile it with the CoffeeScript command line tool.

`coffee -o dist/ -c src/*.coffee && coffee -c spec/*.coffee && sass src/spaceFrame.css.sass dist/spaceFrame.css`

## Testing

### Dependencies

* Node.js & NPM
  * From [nodejs.org](http://nodejs.org)
  * Using a [package manager](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager)
    * HomeBrew: 'brew install node'
* [Testem](https://github.com/airportyh/testem)
  * `npm install testem -g`

### Optional

* [PhantomJS](http://phantomjs.org)
  * HomeBrew: `brew install phantomjs`

Simply run `testem`

## Release History
_(Nothing yet)_

## TODO

* TESTS!
* Test with IE
  The jQuery.fx clip animation has issues in IE with using 'clip' as a css property.  Need to investigate how the jquery.fx.animate function handles css properties.
* Add functionality to iOS
  Need to integrate iOS' touchmove event into the spaceFrame
