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
      axis: null
      lockScrubber: true
      position:
        x: 0
        y: 0

    _create: ->
      @$scrubber = @element.find('.space-scrubber')
      @$panels = @element.find('.space-panel')

      # reverse z-indexing stacking to match markup
      $(@$panels.get().reverse()).each (i, el) ->
        $(el).css
          zIndex: i + 1

      @_events()

    _init: ->
      # RESIZE
      # remove any sizing that might exist
      @element.css
        width: 'auto'
        height: 'auto'

      # get size of first panel
      @panelWidth = @$panels.eq(0).outerWidth()
      @panelHeight = @$panels.eq(0).outerHeight()

      # reset the space frame size
      @element.css
        width: @panelWidth
        height: @panelHeight

      # SET OPTIONS
      # set axis
      unless @options.axis
        @options.axis = @element.data('space-axis')

      # remove css transitions
      @$scrubber.add(@$panels).css
        transitionProperty: 'none'

      # set initial clipping
      @$panels.css
        position: 'absolute'
        clip: "rect(0px, #{@panelWidth}px, #{@panelHeight}px, 0)"

      # make sure all elements ar visible
      @$scrubber.add(@$panels).show()

      # move the scrubber into starting position
      @_positionScrubber @options.position.x, @options.position.y
      @_clipPanels @options.position.x, @options.position.y

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

      $('body').on 'mousemove touchmove', (e) =>
        return unless drag
        return if Modernizr?.touch && e.type == 'mousemove'
        e.preventDefault()

        eventPosition = @_getPositionFromEvent e
        left = eventPosition.x - @options.position.x
        top = eventPosition.y - @options.position.y

        # limit to space frame
        left = 0 if left < 0
        left = @panelWidth if left > @panelWidth
        top = 0 if top < 0
        top = @panelHeight if top > @panelHeight

        @_positionScrubber left, top
        @_clipPanels left, top

      $('body').on 'mouseup touchend', (e) =>
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
      lock = @options.lockScrubber
      axis = @options.axis

      if lock && axis
        if axis == 'x'
          @$scrubber.css
            left: x
        else if axis == 'y'
          @$scrubber.css
            top: y
      else
        @$scrubber.css
          left: x
          top: y

    _clipPanels: (x, y) ->
      scrubberLeft = "#{x}px"
      scrubberTop = "#{y}px"
      panelWidth = "#{@panelWidth}px"
      panelHeight = "#{@panelHeight}px"

      if @options.axis == 'x'
        @$panels.eq(0).css
          clip: "rect(0px, #{panelWidth}, #{panelHeight}, #{scrubberLeft})"
        @$panels.eq(1).css
          clip: "rect(0px, #{scrubberLeft}, #{panelHeight}, 0px)"
      else if @options.axis == 'y'
        @$panels.eq(0).css
          clip: "rect(#{scrubberTop}, #{panelWidth}, #{panelHeight}, 0px)"
        @$panels.eq(1).css
          clip: "rect(0px, #{panelWidth}, #{scrubberTop}, 0px)"
      else
        @$panels.eq(0).css
          clip: "rect(#{scrubberTop}, #{panelWidth}, #{panelHeight}, #{scrubberLeft})"
        @$panels.eq(1).css
          clip: "rect(#{scrubberTop}, #{scrubberLeft}, #{panelHeight}, 0px)"
        @$panels.eq(2).css
          clip: "rect(0px, #{panelWidth}, #{scrubberTop}, #{scrubberLeft})"
        @$panels.eq(3).css
          clip: "rect(0px, #{scrubberLeft}, #{scrubberTop}, 0px)"

    animate: (x, y, duration = @options.transitionDuration, timing = @options.transitionTiming) ->
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

    refresh: ->
      # set position
      @options.position.x = 0
      @options.position.y = 0

      @_init()

    destroy: ->
      @$scrubber.hide()
      @$panels.not(@$panels.eq(0)).hide()

      @$panels.eq(0).css
        position: 'relative'

      @$panels.css
        clip: 'inherit'
