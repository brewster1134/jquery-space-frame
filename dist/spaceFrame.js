/*! Space Frame - v0.1.0 - 2012-08-22
* https://github.com/brewster1134/jquery-space-frame
* Copyright (c) 2012 Ryan Brewster; Licensed MIT */

var console;

if (!window.console) {
  console = {
    log: function() {}
  };
}

(function($) {
  var clipPanel, clipPanels, methods, resize;
  methods = {
    init: function(options) {
      return this.each(function() {
        var $this, bottomPanels, contents, data, leftPanels, panelIndex, rightPanels, scrubber, topPanels;
        $this = $(this);
        data = $this.data('space-frame');
        if (!data) {
          $this.data('space-frame', {
            target: $this
          });
          scrubber = $this.find('.space-scrubber');
          contents = $this.find('.space-panel');
          $this.panelOne = $(contents.get(0));
          $this.panelTwo = $(contents.get(1));
          $this.panelThree = $(contents.get(2));
          $this.panelFour = $(contents.get(3));
          leftPanels = $this.panelOne.add($this.panelThree);
          rightPanels = $this.panelTwo.add($this.panelFour);
          topPanels = $this.panelOne.add($this.panelTwo);
          bottomPanels = $this.panelThree.add($this.panelFour);
          $this.maxContentWidth = null;
          $this.maxContentHeight = null;
          panelIndex = contents.length;
          if ($this.hasClass('x')) {
            if (contents.length !== 2) {
              console.warn('There should only be 2 panels for an x axis space frame!');
            }
            $this.restrictAxis = 'x';
          } else if ($this.hasClass('y')) {
            if (contents.length !== 2) {
              console.warn('There should only be 2 panels for a y axis space frame!');
            }
            $this.restrictAxis = 'y';
          }
          $this.css({
            width: function() {
              contents.each(function() {
                if (!$(this).is(':empty')) {
                  return $this.maxContentWidth = Math.max($this.maxContentWidth, $(this).width());
                }
              });
              return $this.maxContentWidth;
            },
            height: function() {
              contents.each(function() {
                if (!$(this).is(':empty')) {
                  return $this.maxContentHeight = Math.max($this.maxContentHeight, $(this).height());
                }
              });
              return $this.maxContentHeight;
            }
          });
          scrubber.css({
            display: 'block',
            marginTop: (scrubber.height() / 2) * -1,
            marginBottom: (scrubber.height() / 2) * -1,
            marginLeft: (scrubber.width() / 2) * -1,
            marginRight: (scrubber.width() / 2) * -1,
            top: $this.maxContentHeight,
            left: $this.maxContentWidth
          });
          contents.css({
            clip: 'rect(0px, ' + $this.maxContentWidth + 'px, ' + $this.maxContentHeight + 'px, 0px)'
          });
          contents.each(function() {
            $(this).css({
              zIndex: panelIndex
            });
            return panelIndex--;
          });
          leftPanels.css({
            left: 0
          });
          rightPanels.css({
            right: 0
          });
          topPanels.css({
            top: 0
          });
          bottomPanels.css({
            bottom: 0
          });
          scrubber.draggable({
            containment: 'parent',
            drag: function(e, ui) {
              return clipPanels($this, ui.position.left, ui.position.top, false);
            }
          });
          if ($this.restrictAxis) {
            scrubber.draggable('option', 'axis', $this.restrictAxis);
          }
          return scrubber.on({
            touchmove: function(e) {}
          });
        }
      });
    },
    animate: function(positionArray) {
      return this.each(function() {
        var $this, xPos, yPos;
        if ($(this).data('spaceFrame')) {
          $this = $(this).data('spaceFrame').target;
          xPos = positionArray[0];
          yPos = positionArray[1];
          return clipPanels($this, xPos, yPos, true);
        }
      });
    },
    refresh: function() {
      return this.each(function() {
        var $this;
        $this = $(this);
        if ($(this).data('spaceFrame')) {
          $this.data('spaceFrame', null);
        }
        return $this.spaceFrame('init');
      });
    },
    destroy: function() {
      return this.each(function() {
        var $this;
        $this = $(this);
        $this.find('.space-scrubber').hide();
        $this.find('.space-panel').css('clip', '');
        return $this.data('spaceFrame', null);
      });
    }
  };
  $.fn.spaceFrame = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === "object" || !method) {
      return methods.init.apply(this, arguments);
    } else {
      return $.error("Method " + method + " does not exist for the spaceFrame");
    }
  };
  resize = function(spaceFrame) {
    return console.log(spaceFrame.data('spaceFrame'));
  };
  clipPanels = function(spaceFrame, xPos, yPos, animate) {
    if (animate == null) {
      animate = true;
    }
    if (spaceFrame.restrictAxis === 'x') {
      clipPanel(spaceFrame.panelOne, 0, xPos, spaceFrame.maxContentHeight, 0, animate);
      clipPanel(spaceFrame.panelTwo, 0, spaceFrame.maxContentWidth, spaceFrame.maxContentHeight, xPos, animate);
    } else if (spaceFrame.restrictAxis === 'y') {
      clipPanel(spaceFrame.panelOne, 0, spaceFrame.maxContentWidth, yPos, 0, animate);
      clipPanel(spaceFrame.panelTwo, yPos, spaceFrame.maxContentWidth, spaceFrame.maxContentHeight, 0, animate);
    } else {
      clipPanel(spaceFrame.panelOne, 0, xPos, yPos, 0, animate);
      clipPanel(spaceFrame.panelTwo, 0, spaceFrame.maxContentWidth, yPos, xPos, animate);
      clipPanel(spaceFrame.panelThree, yPos, xPos, spaceFrame.maxContentHeight, 0, animate);
      clipPanel(spaceFrame.panelFour, yPos, spaceFrame.maxContentWidth, spaceFrame.maxContentHeight, xPos, animate);
    }
    if (animate === true) {
      return spaceFrame.find('.space-scrubber').animate({
        top: xPos,
        left: yPos
      });
    }
  };
  return clipPanel = function(panel, top, right, bottom, left, animate) {
    var clipCss, scrubber;
    clipCss = function(panel) {
      return panel.css({
        clip: 'rect(' + top + 'px, ' + right + 'px, ' + bottom + 'px, ' + left + 'px)'
      });
    };
    if (animate === true) {
      scrubber = $(panel.parent()).find('.space-scrubber');
      return panel.stop().animate({
        clip: 'rect(' + top + 'px, ' + right + 'px, ' + bottom + 'px, ' + left + 'px)'
      }, {
        step: function(now, fx) {
          var clipRE, endRE, startRE;
          clipRE = /rect\(([0-9.]{1,})(px|em)[,]? ([0-9.]{1,})(px|em)[,]? ([0-9.]{1,})(px|em)[,]? ([0-9.]{1,})(px|em)\)/;
          startRE = fx.start.match(clipRE);
          endRE = fx.end.match(clipRE);
          top = parseInt(startRE[1], 10) + fx.pos * (parseInt(endRE[1], 10) - parseInt(startRE[1], 10));
          right = parseInt(startRE[3], 10) + fx.pos * (parseInt(endRE[3], 10) - parseInt(startRE[3], 10));
          bottom = parseInt(startRE[5], 10) + fx.pos * (parseInt(endRE[5], 10) - parseInt(startRE[5], 10));
          left = parseInt(startRE[7], 10) + fx.pos * (parseInt(endRE[7], 10) - parseInt(startRE[7], 10));
          return clipCss(panel);
        }
      }, 10000);
    } else {
      return clipCss(panel);
    }
  };
})(jQuery);
