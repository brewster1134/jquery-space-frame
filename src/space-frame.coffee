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
      transitionDuration: 200
      transitionTiming: 'ease'
      axis: null
      lockScrubber: true
      position:
        x: 0
        y: 0

    # Find the neccessary elements and set basic attributes
    #
    # @return {Object} the space frame jquery-ui object
    # @api private
    #
    _create: ->
      @$scrubber = @element.find('.space-scrubber')
      @$panels = @element.find('.space-panel')

      # remove css transitions
      @$scrubber.add(@$panels).css
        transitionProperty: 'none'

      # remove any sizing that might exist
      @element.css
        width: 'auto'
        height: 'auto'

      # reverse z-indexing stacking to match markup
      $(@$panels.get().reverse()).each (i, el) ->
        $(el).css
          zIndex: i + 1

      @_events()

      return this

    # Size the space frame based on content, determine if 2 or 4 panel
    #
    # @return {Object} the space frame jquery-ui object
    # @api private
    #
    _init: ->

      # get size of first panel
      @panelWidth = @$panels.eq(0).outerWidth()
      @panelHeight = @$panels.eq(0).outerHeight()

      # reset the space frame size
      @element.css
        width: @panelWidth
        height: @panelHeight

      # set axis
      unless @options.axis
        @options.axis = @element.data('space-axis')

      # set initial clipping
      @$panels.css
        position: 'absolute'
        clip: "rect(0px, #{@panelWidth}px, #{@panelHeight}px, 0)"

      # make sure all elements ar visible
      @$scrubber.add(@$panels).show()

      # move the scrubber into starting position
      @_positionScrubber @options.position.x, @options.position.y
      @_clipPanels @options.position.x, @options.position.y

      return this

    # Animate to the provided coordinates
    #
    # @example
    #   $('.space-frame').space-frame 'animate', 50, 100, 200, 'ease-out'
    #
    # ** REQUIRED **
    # @param {Integer} X coordinate relative from the left of the space frame
    # @param {Integer} Y coordinate relative from the top of the space frame
    #
    # ** OPTIONAL **
    # @param {String} CSS3 allowed value for animation-duration in milliseconds
    # @param {String} CSS3 allowed value for animation-timing-function
    #
    # @return {Object} the space frame jquery-ui object
    # @api public
    #
    animate: (x, y, duration = @options.transitionDuration, timing = @options.transitionTiming) ->

      # enable css transitions
      @$scrubber.css
        transitionProperty: 'left, top'
        transitionDuration: "#{duration}ms"
        transitionTiming: timing

      @$panels.css
        transitionProperty: 'clip'
        transitionDuration: "#{duration}ms"
        transitionTiming: timing

      @options.position.x = x
      @options.position.y = y
      @_positionScrubber x, y
      @_clipPanels x, y

      return this

    # Refresh the space frame in case of changes to content
    #
    # @example
    #   $('.space-frame').space-frame 'refresh'
    #
    # @return {Object} the space frame jquery-ui object
    # @api public
    #
    refresh: ->
      # reset position
      @options.position.x = 0
      @options.position.y = 0

      @_init()

      return this

    # Hides the scrubber, and all but the first panel content
    #
    # @example
    #   $('.space-frame').space-frame 'destroy'
    #
    # @return {Object} the space frame jquery-ui object
    # @api public
    #
    destroy: ->
      @$scrubber.hide()
      @$panels.not(@$panels.eq(0)).hide()

      @$panels.eq(0).css
        position: 'relative'

      @$panels.css
        clip: 'inherit'

      return this

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

    # make sure coordinates are within the space frame's boundaries
    #
    _normalizeCoordinates: (x, y) ->
      # limit to space frame
      x = 0 if x < 0
      x = @panelWidth if x > @panelWidth
      y = 0 if y < 0
      y = @panelHeight if y > @panelHeight

      return {
        x: x
        y: y
      }

    # move the scrubber into position to match the clipped panels
    #
    _positionScrubber: (x, y) ->
      axis = @options.axis
      lock = @options.lockScrubber
      coords = @_normalizeCoordinates x, y

      if lock && axis
        if axis == 'x'
          @$scrubber.css
            left: coords.x
        else if axis == 'y'
          @$scrubber.css
            top: coords.y
      else
        @$scrubber.css
          left: coords.x
          top: coords.y

    _clipPanels: (x, y) ->
      coords = @_normalizeCoordinates x, y
      scrubberLeft = "#{coords.x}px"
      scrubberTop = "#{coords.y}px"
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
