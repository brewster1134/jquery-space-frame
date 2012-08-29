# Space Frame

A space frame.

## Getting Started
Download the [production version][min] or the [development version][max].
Download the [CSS][css] file

[min]: https://raw.github.com/brewster1134/jquery-space-frame/master/dist/spaceFrame.min.js
[max]: https://raw.github.com/brewster1134/jquery-space-frame/master/dist/spaceFrame.js
[css]: https://raw.github.com/brewster1134/jquery-space-frame/master/dist/spaceFrame.css

In your web page, include the neccessary js and css:

```html (shown in HAML)
%head
  %link{ type: "text/css", rel: "stylesheet", media: "all", href: "spaceFrame.css" }
  %script{ type: "text/javascript", src: "https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" }
  %script{ type: "text/javascript", src: "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/jquery-ui.min.js" }
  %script{ type: "text/javascript", src: "spaceFrame.min.js" }
```

## Documentation

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

## Release History
_(Nothing yet)_

## TODO

* Write _actual_ qUnit Tests
* Fix animation with WebKit
  The jQuery.fx clip animation has issues in WebKit with jumping to the last frame.
* Test with IE
  The jQuery.fx clip animation has issues in IE with using 'clip' as a css property.  Need to investigate how the jquery.fx.animate function handles css properties.
* Add functionality to iOS
  Need to integrate iOS' touchmove event into the spaceFrame

#### 3rd Party dependencies
* Update `grunt.js` when grunt-sass resolves [Issue 2](https://github.com/sindresorhus/grunt-sass/issues/2)
  _Currently running `grunt sass` throws a `Segmentation fault: 11` exception_
* Update `grunt.js` & `demo/index.html.haml` when grunt-coffee approves [Pull Request 14](https://github.com/avalade/grunt-coffee/pull/14) to support passing a blank string as the extension.
  _Currently running `grunt-coffee` compiles `.js.coffee` files into `.js.js`

## License
Copyright (c) 2012 Ryan Brewster
Licensed under the MIT license.

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt](https://github.com/cowboy/grunt).

### Important notes
Please don't edit files in the `dist` subdirectory as they are generated via grunt. You'll find source code in the `src` subdirectory!

While grunt can run the included unit tests via PhantomJS, this shouldn't be considered a substitute for the real thing. Please be sure to test the `test/*.html` unit test file(s) in _actual_ browsers.

### Installing grunt
_This assumes you have [node.js](http://nodejs.org/) and [npm](http://npmjs.org/) installed already._

1. Test that grunt is installed globally by running `grunt --version` at the command-line.
1. If grunt isn't installed globally, run `npm install -g grunt` to install the latest version. _You may need to run `sudo npm install -g grunt`._
1. From the root directory of this project, run `npm install` to install the project's dependencies.

### Installing PhantomJS

In order for the qunit task to work properly, [PhantomJS](http://www.phantomjs.org/) must be installed and in the system PATH (if you can run "phantomjs" at the command line, this task should work).

Unfortunately, PhantomJS cannot be installed automatically via npm or grunt, so you need to install it yourself. There are a number of ways to install PhantomJS.

* [PhantomJS and Mac OS X](http://ariya.ofilabs.com/2012/02/phantomjs-and-mac-os-x.html)
* [PhantomJS Installation](http://code.google.com/p/phantomjs/wiki/Installation) (PhantomJS wiki)

Note that the `phantomjs` executable needs to be in the system `PATH` for grunt to see it.

* [How to set the path and environment variables in Windows](http://www.computerhope.com/issues/ch000549.htm)
* [Where does $PATH get set in OS X 10.6 Snow Leopard?](http://superuser.com/questions/69130/where-does-path-get-set-in-os-x-10-6-snow-leopard)
* [How do I change the PATH variable in Linux](https://www.google.com/search?q=How+do+I+change+the+PATH+variable+in+Linux)
