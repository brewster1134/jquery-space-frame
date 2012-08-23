#
# * spaceFrame
# * https://github.com/brewster1134/jquery-space-frame
# *
# * Copyright (c) 2012 Ryan Brewster
# * Licensed under the MIT license.
#

unless window.console
  console = log: ->

(($) ->
  methods =
    init: (options) ->
      @each ->
        $this = $(@)
        data = $this.data('space-frame')

        unless data
          $this.data 'space-frame',
            target: $this

          scrubber = $this.find('.space-scrubber')
          contents = $this.find('.space-panel')
          $this.panelOne = $(contents.get(0))
          $this.panelTwo = $(contents.get(1))
          $this.panelThree = $(contents.get(2))
          $this.panelFour = $(contents.get(3))
          leftPanels = $this.panelOne.add $this.panelThree
          rightPanels = $this.panelTwo.add $this.panelFour
          topPanels = $this.panelOne.add $this.panelTwo
          bottomPanels = $this.panelThree.add $this.panelFour

          $this.maxContentWidth = null
          $this.maxContentHeight = null
          panelIndex = contents.length

          if $this.hasClass 'x'
            console.warn 'There should only be 2 panels for an x axis space frame!' if contents.length != 2
            $this.restrictAxis = 'x'
          else if $this.hasClass 'y'
            console.warn 'There should only be 2 panels for a y axis space frame!' if contents.length != 2
            $this.restrictAxis = 'y'

          $this.css
            width: ->
              contents.each ->
                $this.maxContentWidth = Math.max($this.maxContentWidth, $(@).width()) unless $(@).is(':empty')
              $this.maxContentWidth
            height: ->
              contents.each ->
                $this.maxContentHeight = Math.max($this.maxContentHeight, $(@).height()) unless $(@).is(':empty')
              $this.maxContentHeight
          scrubber.css
            display: 'block',
            marginTop: (scrubber.height() / 2) * -1,
            marginBottom: (scrubber.height() / 2) * -1,
            marginLeft: (scrubber.width() / 2) * -1,
            marginRight: (scrubber.width() / 2) * -1,
            top:  $this.maxContentHeight,
            left:  $this.maxContentWidth
          contents.css
            clip: 'rect(0px, ' + $this.maxContentWidth + 'px, ' + $this.maxContentHeight + 'px, 0px)'
          contents.each ->
            $(@).css
              zIndex: panelIndex
            panelIndex--
          leftPanels.css
            left: 0
          rightPanels.css
            right: 0
          topPanels.css
            top: 0
          bottomPanels.css
            bottom: 0

          ## EVENTS
          scrubber.draggable
            containment: 'parent',
            drag: (e, ui) ->
              clipPanels $this, ui.position.left, ui.position.top, false
          # restict axis'
          scrubber.draggable 'option', 'axis', $this.restrictAxis if $this.restrictAxis

          # iOS
          scrubber.on
            touchmove: (e) ->
              # e.preventDefault()
              # xPos = e.originalEvent.changedTouches[0].pageX
              # yPos = e.originalEvent.changedTouches[0].pageY

    animate: (positionArray) ->
      @each ->
        if $(@).data('spaceFrame')
          $this = $(@).data('spaceFrame').target
          xPos = positionArray[0]
          yPos = positionArray[1]
          clipPanels $this, xPos, yPos, true

    refresh: ->
      @each ->
        $this = $(@)
        $this.data('spaceFrame', null) if $(@).data('spaceFrame')
        $this.spaceFrame('init')

    destroy: ->
      @each ->
        $this = $(@)
        $this.find('.space-scrubber').hide()
        $this.find('.space-panel').css('clip', '')
        $this.data('spaceFrame', null)


  $.fn.spaceFrame = (method) ->
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method
      methods.init.apply this, arguments
    else
      $.error "Method " + method + " does not exist for the spaceFrame"

  resize = (spaceFrame) ->
    console.log spaceFrame.data('spaceFrame')


  clipPanels = (spaceFrame, xPos, yPos, animate = true) ->
    if spaceFrame.restrictAxis == 'x'
      clipPanel spaceFrame.panelOne, 0, xPos, spaceFrame.maxContentHeight, 0, animate
      clipPanel spaceFrame.panelTwo, 0, spaceFrame.maxContentWidth, spaceFrame.maxContentHeight, xPos, animate
    else if spaceFrame.restrictAxis == 'y'
      clipPanel spaceFrame.panelOne, 0, spaceFrame.maxContentWidth, yPos, 0, animate
      clipPanel spaceFrame.panelTwo, yPos, spaceFrame.maxContentWidth, spaceFrame.maxContentHeight, 0, animate
    else
      clipPanel spaceFrame.panelOne, 0, xPos, yPos, 0, animate
      clipPanel spaceFrame.panelTwo, 0, spaceFrame.maxContentWidth, yPos, xPos, animate
      clipPanel spaceFrame.panelThree, yPos, xPos, spaceFrame.maxContentHeight, 0, animate
      clipPanel spaceFrame.panelFour, yPos, spaceFrame.maxContentWidth, spaceFrame.maxContentHeight, xPos, animate
    if animate == true
      spaceFrame.find('.space-scrubber').animate
        top: xPos,
        left: yPos

  clipPanel = (panel, top, right, bottom, left, animate) ->
    clipCss = (panel) ->
      panel.css
        clip: 'rect(' + top + 'px, ' + right + 'px, ' + bottom + 'px, ' + left + 'px)'

    if animate == true
      scrubber = $(panel.parent()).find('.space-scrubber')
      panel.stop().animate
        clip: 'rect(' + top + 'px, ' + right + 'px, ' + bottom + 'px, ' + left + 'px)'
      , step: (now, fx) ->
          clipRE = /rect\(([0-9.]{1,})(px|em)[,]? ([0-9.]{1,})(px|em)[,]? ([0-9.]{1,})(px|em)[,]? ([0-9.]{1,})(px|em)\)/
          startRE = fx.start.match clipRE
          endRE = fx.end.match clipRE

          top = parseInt(startRE[1], 10) + fx.pos * (parseInt(endRE[1], 10) - parseInt(startRE[1], 10))
          right = parseInt(startRE[3], 10) + fx.pos * (parseInt(endRE[3], 10) - parseInt(startRE[3], 10))
          bottom = parseInt(startRE[5], 10) + fx.pos * (parseInt(endRE[5], 10) - parseInt(startRE[5], 10))
          left = parseInt(startRE[7], 10) + fx.pos * (parseInt(endRE[7], 10) - parseInt(startRE[7], 10))

          clipCss panel
        , 10000
    else
      clipCss panel

) jQuery

