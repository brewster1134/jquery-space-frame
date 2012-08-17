# jQuery Space Frame

## Usage

### Javascript

The Space Frame can be initialized with the following javascript

#### CoffeeScript

``` coffee-script
$(window).load ->
  $('.space-frame').SpaceFrame()
```

#### JavaScript

``` s
$(window).load(function(){
  $('.space-frame').SpaceFrame();
});
```

`$(window).load()` is needed instead of `$(document).ready()` because of issues
with WebKit computing width/height of the various panels.

### HTML

An ID can be added to the `.space-frame` element for initialization, but the
`space-frame` class needs to remain for CSS purposes.

To use a 2 panel space frame, add a `x` or `y` class to the `space-frame`
element.  `x` will create a left/right space frame on the x axis, and `y` will
create a top/bottom space frame on the y axis.

Panels are not only restricted to images.  Any content can be used *however* the
space frame is sized based on the computed width/height of the largest panel.
Being explicit with the sizing of content will present more desirable results :)

#### HAML

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

#### HTML

``` html
<h1>4 Panel</h1>
<div class='space-frame' id='four_panel'>
  <div class='space-scrubber'></div>
  <div class='space-panel'>
    <img src='kitty.jpg' />
  </div>
  <div class='space-panel'>
    <img src='kitty_red.jpg' />
  </div>
  <div class='space-panel'>
    <img src='kitty_green.jpg' />
  </div>
  <div class='space-panel'>
    <img src='kitty_blue.jpg' />
  </div>
</div>
<h1>2 Panel Left/Right</h1>
<div class='space-frame x' id='two_panel_left_right'>
  <div class='space-scrubber'></div>
  <div class='space-panel'>
    <img src='kitty_red.jpg' />
  </div>
  <div class='space-panel'>
    <img src='kitty_blue.jpg' />
  </div>
</div>
<h1>2 Panel Top/Bottom</h1>
<div class='space-frame y' id='two_panel_top_bottom'>
  <div class='space-scrubber'></div>
  <div class='space-panel'>
    <img src='kitty_green.jpg' />
  </div>
  <div class='space-panel'>
    <img src='kitty_blue.jpg' />
  </div>
</div>
```

## Development

The javascript source is written in coffeescript.  To compile it you will need
to install node.js, npm, and the coffee-script node package.

http://nodejs.org/download/

after you have node.js and npm installed...

``` bash
npm install coffee-script
bundle install
bundle exec rake watch
```

The assets are now being watched and compiled automatically when you save.

A demo can be viewed under `compiled/demo/index.html`

# TODO:

* initial animation/callback
* Test IE compatibility
* iOS compatible
