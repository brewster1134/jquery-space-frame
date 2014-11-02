# Space Frame
---

![Space Frame](http://i.imgur.com/W9sXrgK.gif)

[js]: https://raw.github.com/brewster1134/jquery-space-frame/master/lib/space-frame.js
[css]: https://raw.github.com/brewster1134/jquery-space-frame/master/lib/space-frame.css

Space Frame allows you to use up to 4 pieces of content to transition between using a scrubber.  You can use 2 pieces of content and restrict movement to just horizontal or vertical as well.

The example above (as well as the demo) use 4 images, but you can use any html content to transition between.

### Support

* Chrome
* Firefox
* Safari
* IE9

### Dependencies
* [jQuery](http://jquery.com) version 1.8.0 or greater
* [jQuery UI Widget](http://jqueryui.com/widget/)

### Installing
Load both the css and javascript on your page.

You can install through bower

`bower install brewster1134/jquery-space-frame -S`

Or...
Download the [JS][js]
Download the [CSS][css]

#### HTML

To use a 2 panel space frame, add a `space-axis-x` or `space-axis-y` class to the `space-frame`
element.  `x` will create a left/right space frame on the x axis, and `y` will
create a top/bottom space frame on the y axis.

Panels are not only restricted to images.  Any content can be used *however* the
space frame is sized based on the computed width/height of the first panel.
_Being explicit with the sizing of content will present more desirable results :)_

```html
<div class="space-frame" id="four_panel">
  <div class="space-panel"><img src="kitty.jpg" /></div>
  <div class="space-panel"><img src="kitty_red.jpg" /></div>
  <div class="space-panel"><img src="kitty_green.jpg" /></div>
  <div class="space-panel"><img src="kitty_blue.jpg" /></div>
  <div class="space-scrubber"></div>
</div>

<div class="space-frame" data-space-axis="x" id="two_panel_left_right">
  <div class="space-panel"><img src="kitty_red.jpg" /></div>
  <div class="space-panel"><img src="kitty_blue.jpg" /></div>
  <div class="space-scrubber"></div>
</div>

<div class="space-frame" data-space-axis="y" id="two_panel_top_bottom">
  <div class="space-panel"><img src="kitty_green.jpg" /></div>
  <div class="space-panel"><img src="kitty_blue.jpg" /></div>
  <div class="space-scrubber"></div>
</div>
```

#### JS

Initialize the space frame.

The space frame sets its size based on the width and height of the first panel.  This means the content needs to be loaded (esp images!), or the size be explicitly set before initializing the space frame.

* Explicitly set the width and height on the `.space-panel` elements with CSS
* If you are using images, you can use a library such as [imagesloaded](https://github.com/desandro/imagesloaded) or explicitly set width and height on your space-panels to ensure the desired behavior.
* You may also be able to use jquery's [.load](http://api.jquery.com/load-event/) event.

```coffee
$('#my-space-frame').spaceframe()
```

## Methods

---
#### `animate`
Animate the space frame to given coordinates.

The `animate` method accepts 4 arguments. Required x & y coordinates, and optional duration and timing values.

X & Y coordinates are relative to the top left of the space frame.

Duration & timing values can be any allowed CSS3 values.
[duration](http://www.w3schools.com/cssref/css3_pr_animation-duration.asp)
[timing](http://www.w3schools.com/cssref/css3_pr_animation-timing-function.asp)

```coffee
$('#my-space-frame').spaceframe 'animate', 50, 100, '2s', 'ease-out'
```

---
#### `refresh`
Reset the scrubber back to its initial position and resize the space frame based on the computed width/height of the 1st panel.

This is helpful for responsive sites where the content in the panels might change.

The `refresh` method accepts no arguments.

```coffee
$('#my-space-frame').spaceframe 'refresh'
```

---
#### `destroy`
Remove the scrubber, and show only the first panel content.

The `destroy` method accepts no arguments.

```coffee
$('#my-space-frame').spaceframe 'destroy'
```

#### Demo

A full working demo is available at `demo/index.html`

## Development & Testing
### Dependencies

Use [yuyi](https://github.com/brewster1134/yuyi) to install your dependencies

```shell
yuyi -m https://raw.githubusercontent.com/brewster1134/jquery-space-frame/master/yuyi_menu
bundle install
npm install
bower install
```

Run `testem` to watch for file changes, compile them, and run the tests.

Do **NOT** modify any files in the `lib` directory!  Modify the files in the `src` directory and compile them into the lib directory. This will be done automatically if you are running testem.
