###
# * space-frame
# * https://github.com/brewster1134/jquery-space-frame
# *
# * Copyright (c) 2012 Ryan Brewster
# * Licensed under the MIT license.
###

((root, factory) ->
  if typeof define == 'function' && define.amd
    define [
      'jquery'
      'widget'
    ], ($) ->
      factory $
  else
    factory jQuery
) @, ($) ->

  $.widget 'ui.spaceframe',
    widgetEventPrefix: 'spaceframe'
    options:
      transitionDuration: 0.15
      transitionTiming: 'ease'
      position:
        x: 0
        y: 0

    _create: ->
      @$scrubber = @element.find('.space-scrubber')
      @$panels = @element.find('.space-panel')

      @$scrubber.show()
      @$panels.show()

      # get size of first panel
      @panelWidth = @$panels.eq(0).outerWidth()
      @panelHeight = @$panels.eq(0).outerHeight()

      @options.position.x = @panelWidth
      @options.position.y = @panelHeight

      @$scrubber.css
        left: @options.position.x
        top: @options.position.y

      # set size of space frame to match the first panel
      @element.css
        width: @panelWidth
        height: @panelHeight

      # set the default styles to the panels
      @$panels.css
        position: 'absolute'
        clip: "rect(0px, #{@panelWidth}px, #{@panelHeight}px, 0)"

      # reverse z-indexing stacking to match markup
      $(@$panels.get().reverse()).each (i, el) ->
        $(el).css
          zIndex: i + 1

      @_events()

    _events: ->
      drag = false

      @$scrubber.on 'mousedown touchstart', (e) =>
        return if Modernizr?.touch && e.type == 'mousedown'
        e.preventDefault()

        # remove css transitions
        @$scrubber.add(@$panels).css
          transitionProperty: 'none'

        drag = true
        eventPosition = @_getPositionFromEvent e
        @options.position.x = eventPosition.x - @options.position.x
        @options.position.y = eventPosition.y - @options.position.y

      @element.on 'mousemove touchmove', (e) =>
        return unless drag
        return if Modernizr?.touch && e.type == 'mousemove'
        e.preventDefault()

        eventPosition = @_getPositionFromEvent e
        left = eventPosition.x - @options.position.x
        top = eventPosition.y - @options.position.y

        @_positionScrubber left, top
        @_clipPanels left, top

      @element.on 'mouseup touchend', (e) =>
        return if Modernizr?.touch && e.type == 'mouseup'
        e.preventDefault()

        drag = false
        left = parseInt @$scrubber.css('left')
        top = parseInt @$scrubber.css('top')
        @options.position.x = left
        @options.position.y = top

    _getPositionFromEvent: (event) ->
      if event.type.indexOf('touch') == 0
        x = event.originalEvent.touches[0].clientX
        y = event.originalEvent.touches[0].clientY
      else
        x = event.clientX
        y = event.clientY

      return { x: x, y: y }

    _positionScrubber: (x, y) ->
      @$scrubber.css
        left: x
        top: y

    _clipPanels: (x, y) ->
      scrubberLeft = "#{x}px"
      scrubberTop = "#{y}px"
      panelWidth = "#{@panelWidth}px"
      panelHeight = "#{@panelHeight}px"

      @$panels.eq(0).css
        clip: "rect(0px, #{scrubberLeft}, #{scrubberTop}, 0px)"
      @$panels.eq(1).css
        clip: "rect(0px, #{panelWidth}, #{scrubberTop}, #{scrubberLeft})"
      @$panels.eq(2).css
        clip: "rect(#{scrubberTop}, #{scrubberLeft}, #{panelHeight}, 0px)"

    animate: (x, y, duration = @options.transitionDuration, timing = @options.transitionTiming) ->
      console.log x, y, duration, timing
      # enable css transitions
      @$scrubber.css
        transitionProperty: 'left, top'
        transitionDuration: "#{duration}s"
        transitionTiming: timing

      @$panels.css
        transitionProperty: 'clip'
        transitionDuration: "#{duration}s"
        transitionTiming: timing

      @options.position.x = x
      @options.position.y = y
      @_positionScrubber x, y
      @_clipPanels x, y
