// Generated by CoffeeScript 1.7.1

/*
 * * space-frame
 * * https://github.com/brewster1134/jquery-space-frame
 * *
 * * Copyright (c) 2012 Ryan Brewster
 * * Licensed under the MIT license.
 */

(function() {
  (function(root, factory) {
    if (typeof define === 'function' && define.amd) {
      return define(['jquery', 'widget'], function($) {
        return factory($);
      });
    } else {
      return factory(jQuery);
    }
  })(this, function($) {
    return $.widget('ui.spaceframe', {
      widgetEventPrefix: 'spaceframe',
      options: {
        transitionDuration: 0.15,
        transitionTiming: 'ease',
        position: {
          x: 0,
          y: 0
        }
      },
      _create: function() {
        this.$scrubber = this.element.find('.space-scrubber');
        this.$panels = this.element.find('.space-panel');
        this.panelWidth = this.$panels.eq(0).outerWidth();
        this.panelHeight = this.$panels.eq(0).outerHeight();
        this.options.position.x = this.panelWidth;
        this.options.position.y = this.panelHeight;
        this.$scrubber.css({
          left: this.options.position.x,
          top: this.options.position.y
        });
        this.element.css({
          width: this.panelWidth,
          height: this.panelHeight
        });
        $(this.$panels.get().reverse()).each(function(i, el) {
          return $(el).css({
            zIndex: i + 1
          });
        });
        return this._events();
      },
      _init: function() {
        this.options.position.x = this.panelWidth;
        this.options.position.y = this.panelHeight;
        this.$scrubber.add(this.$panels).css({
          transitionProperty: 'none'
        });
        this._positionScrubber(this.panelWidth, this.panelHeight);
        this.$panels.css({
          position: 'absolute',
          clip: "rect(0px, " + this.panelWidth + "px, " + this.panelHeight + "px, 0)"
        });
        this.$scrubber.show();
        return this.$panels.show();
      },
      _events: function() {
        var drag;
        drag = false;
        this.$scrubber.on('mousedown touchstart', (function(_this) {
          return function(e) {
            var eventPosition;
            if ((typeof Modernizr !== "undefined" && Modernizr !== null ? Modernizr.touch : void 0) && e.type === 'mousedown') {
              return;
            }
            e.preventDefault();
            _this.$scrubber.add(_this.$panels).css({
              transitionProperty: 'none'
            });
            drag = true;
            eventPosition = _this._getPositionFromEvent(e);
            _this.options.position.x = eventPosition.x - _this.options.position.x;
            return _this.options.position.y = eventPosition.y - _this.options.position.y;
          };
        })(this));
        this.element.on('mousemove touchmove', (function(_this) {
          return function(e) {
            var eventPosition, left, top;
            if (!drag) {
              return;
            }
            if ((typeof Modernizr !== "undefined" && Modernizr !== null ? Modernizr.touch : void 0) && e.type === 'mousemove') {
              return;
            }
            e.preventDefault();
            eventPosition = _this._getPositionFromEvent(e);
            left = eventPosition.x - _this.options.position.x;
            top = eventPosition.y - _this.options.position.y;
            _this._positionScrubber(left, top);
            return _this._clipPanels(left, top);
          };
        })(this));
        return this.element.on('mouseup touchend', (function(_this) {
          return function(e) {
            var left, top;
            if ((typeof Modernizr !== "undefined" && Modernizr !== null ? Modernizr.touch : void 0) && e.type === 'mouseup') {
              return;
            }
            e.preventDefault();
            drag = false;
            left = parseInt(_this.$scrubber.css('left'));
            top = parseInt(_this.$scrubber.css('top'));
            _this.options.position.x = left;
            return _this.options.position.y = top;
          };
        })(this));
      },
      _getPositionFromEvent: function(event) {
        var x, y;
        if (event.type.indexOf('touch') === 0) {
          x = event.originalEvent.touches[0].clientX;
          y = event.originalEvent.touches[0].clientY;
        } else {
          x = event.clientX;
          y = event.clientY;
        }
        return {
          x: x,
          y: y
        };
      },
      _positionScrubber: function(x, y) {
        return this.$scrubber.css({
          left: x,
          top: y
        });
      },
      _clipPanels: function(x, y) {
        var panelHeight, panelWidth, scrubberLeft, scrubberTop;
        scrubberLeft = "" + x + "px";
        scrubberTop = "" + y + "px";
        panelWidth = "" + this.panelWidth + "px";
        panelHeight = "" + this.panelHeight + "px";
        this.$panels.eq(0).css({
          clip: "rect(0px, " + scrubberLeft + ", " + scrubberTop + ", 0px)"
        });
        this.$panels.eq(1).css({
          clip: "rect(0px, " + panelWidth + ", " + scrubberTop + ", " + scrubberLeft + ")"
        });
        return this.$panels.eq(2).css({
          clip: "rect(" + scrubberTop + ", " + scrubberLeft + ", " + panelHeight + ", 0px)"
        });
      },
      animate: function(x, y, duration, timing) {
        if (duration == null) {
          duration = this.options.transitionDuration;
        }
        if (timing == null) {
          timing = this.options.transitionTiming;
        }
        this.$scrubber.css({
          transitionProperty: 'left, top',
          transitionDuration: "" + duration + "s",
          transitionTiming: timing
        });
        this.$panels.css({
          transitionProperty: 'clip',
          transitionDuration: "" + duration + "s",
          transitionTiming: timing
        });
        this.options.position.x = x;
        this.options.position.y = y;
        this._positionScrubber(x, y);
        return this._clipPanels(x, y);
      },
      destroy: function() {
        this.$scrubber.hide();
        this.$panels.not(this.$panels.eq(0)).hide();
        this.$panels.eq(0).css({
          position: 'relative'
        });
        return this.$panels.css({
          clip: 'inherit'
        });
      }
    });
  });

}).call(this);
