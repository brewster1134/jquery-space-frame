# Space Frame
---

![Space Frame](http://i.imgur.com/W9sXrgK.gif)

Space Frame allows you to use up to 4 pieces of content to transition between using a scrubber.  You can use 2 pieces of content and restrict movement to just horizontal or vertical as well.

The example above (as well as the demo) use 4 images, but you can use any html content to transition between.

## Support

* Chrome
* Firefox
* Safari
* IE9/IE10 (IE8 and below untested)

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

```html
<div class="space-frame" id="four_panel">
  <div class="space-scrubber"></div>
  <div class="space-panel"><img src="kitty.jpg" /></div>
  <div class="space-panel"><img src="kitty_red.jpg" /></div>
  <div class="space-panel"><img src="kitty_green.jpg" /></div>
  <div class="space-panel"><img src="kitty_blue.jpg" /></div>
</div>

<div class="space-frame x" id="two_panel_left_right">
  <div class="space-scrubber"></div>
  <div class="space-panel"><img src="kitty_red.jpg" /></div>
  <div class="space-panel"><img src="kitty_blue.jpg" /></div>
</div>

<div class="space-frame y" id="two_panel_top_bottom">
  <div class="space-scrubber"></div>
  <div class="space-panel"><img src="kitty_green.jpg" /></div>
  <div class="space-panel"><img src="kitty_blue.jpg" /></div>
</div>
```

#### JS

Initialize the space frame.

The space frame sets its size based on the width and height of the largest panel.  This means the content needs to be loaded, or the size explicitly set before initializing the space frame.

* Explicitly set the width and height on the `.space-panel` elements with CSS
* If you are using images, you can use a library such as [imagesloaded](https://github.com/desandro/imagesloaded) or explicitly set width and height on your space-panels to ensure the desired behavior.
* You may also be able to use jquery's [.load](http://api.jquery.com/load-event/) event.

```js
$('.space-frame').spaceFrame();
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
* Add functionality to iOS
  Need to integrate iOS' touchmove event into the spaceFrame
