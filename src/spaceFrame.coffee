###
# * spaceFrame
# * https://github.com/brewster1134/jquery-space-frame
# *
# * Copyright (c) 2012 Ryan Brewster
# * Licensed under the MIT license.
###

# usage: log('inside coolFunc',this,arguments);
# paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log = ->
  log.history = log.history or [] # store logs to an array for reference
  log.history.push arguments_
  console.log Array::slice.call(arguments_) if @console

(($) ->
  methods =
    init: (options) ->
      defaults =
        speed: 500
      @each ->
        $sf = $(@)
        $sf.options = $.extend options, defaults
        data = $sf.data('space-frame')

        unless data
          $sf.data 'space-frame',
            target: $sf

          scrubber = $sf.find('.space-scrubber')
          contents = $sf.find('.space-panel')
          $sf.panelOne = $(contents.get(0))
          $sf.panelTwo = $(contents.get(1))
          $sf.panelThree = $(contents.get(2))
          $sf.panelFour = $(contents.get(3))
          leftPanels = $sf.panelOne.add $sf.panelThree
          rightPanels = $sf.panelTwo.add $sf.panelFour
          topPanels = $sf.panelOne.add $sf.panelTwo
          bottomPanels = $sf.panelThree.add $sf.panelFour

          $sf.maxContentWidth = null
          $sf.maxContentHeight = null
          panelIndex = contents.length

          if $sf.hasClass 'x'
            console.warn 'There should only be 2 panels for an x axis space frame!' if contents.length != 2
            $sf.restrictAxis = 'x'
          else if $sf.hasClass 'y'
            console.warn 'There should only be 2 panels for a y axis space frame!' if contents.length != 2
            $sf.restrictAxis = 'y'

          $sf.css
            width: ->
              contents.each ->
                $sf.maxContentWidth = Math.max($sf.maxContentWidth, $(@).width()) unless $(@).is(':empty')
              $sf.maxContentWidth
            height: ->
              contents.each ->
                $sf.maxContentHeight = Math.max($sf.maxContentHeight, $(@).height()) unless $(@).is(':empty')
              $sf.maxContentHeight
          scrubber.css
            display: 'block',
            marginTop: (scrubber.height() / 2) * -1,
            marginBottom: (scrubber.height() / 2) * -1,
            marginLeft: (scrubber.width() / 2) * -1,
            marginRight: (scrubber.width() / 2) * -1,
            top:  $sf.maxContentHeight,
            left:  $sf.maxContentWidth
          contents.css
            clip: 'rect(0px, ' + $sf.maxContentWidth + 'px, ' + $sf.maxContentHeight + 'px, 0px)'
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
              clipPanels $sf, ui.position.left, ui.position.top, false
          # restict axis'
          scrubber.draggable 'option', 'axis', $sf.restrictAxis if $sf.restrictAxis

          # iOS TODO
          scrubber.on
            touchmove: (e) ->
              console.log e

    animate: (positionArray) ->
      @each ->
        if $(@).data('space-frame')
          $sf = $(@).data('space-frame').target
          xPos = positionArray[0]
          yPos = positionArray[1]
          clipPanels $sf, xPos, yPos, true

    refresh: ->
      @each ->
        $sf = $(@)
        $sf.data('space-frame', null) if $(@).data('space-frame')
        $sf.spaceFrame('init')

    destroy: ->
      @each ->
        $sf = $(@)
        $sf.find('.space-scrubber').hide()
        $sf.find('.space-panel').css('clip', '')
        $sf.data('space-frame', null)


  $.fn.spaceFrame = (method) ->
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method
      methods.init.apply this, arguments
    else
      $.error "Method " + method + " does not exist for the spaceFrame"

  clipPanels = (sf, xPos, yPos, animate = true) ->
    if sf.restrictAxis == 'x'
      clipPanel sf.panelOne, 0, xPos, sf.maxContentHeight, 0, animate
      clipPanel sf.panelTwo, 0, sf.maxContentWidth, sf.maxContentHeight, xPos, animate
    else if sf.restrictAxis == 'y'
      clipPanel sf.panelOne, 0, sf.maxContentWidth, yPos, 0, animate
      clipPanel sf.panelTwo, yPos, sf.maxContentWidth, sf.maxContentHeight, 0, animate
    else
      clipPanel sf.panelOne, 0, xPos, yPos, 0, animate
      clipPanel sf.panelTwo, 0, sf.maxContentWidth, yPos, xPos, animate
      clipPanel sf.panelThree, yPos, xPos, sf.maxContentHeight, 0, animate
      clipPanel sf.panelFour, yPos, sf.maxContentWidth, sf.maxContentHeight, xPos, animate
    if animate
      sf.find('.space-scrubber').animate
        top: yPos,
        left: xPos
      , sf.options.speed

  clipPanel = (panel, top, right, bottom, left, animate) ->
    sf = panel.parent().data('space-frame').target
    clipCss = (panel) ->
      panel.css
        clip: 'rect(' + top + 'px, ' + right + 'px, ' + bottom + 'px, ' + left + 'px)'

    if animate
      panel.stop(true).animate
        clip: 'rect(' + top + 'px, ' + right + 'px, ' + bottom + 'px, ' + left + 'px)'
      ,
        duration: sf.options.speed,
        step: (now, fx) ->
          clipRE = /rect\(([0-9.]{1,})(px|em)[,]? ([0-9.]{1,})(px|em)[,]? ([0-9.]{1,})(px|em)[,]? ([0-9.]{1,})(px|em)\)/
          startRE = fx.start.match clipRE
          endRE = fx.end.match clipRE

          top = parseInt(startRE[1], 10) + fx.pos * (parseInt(endRE[1], 10) - parseInt(startRE[1], 10))
          right = parseInt(startRE[3], 10) + fx.pos * (parseInt(endRE[3], 10) - parseInt(startRE[3], 10))
          bottom = parseInt(startRE[5], 10) + fx.pos * (parseInt(endRE[5], 10) - parseInt(startRE[5], 10))
          left = parseInt(startRE[7], 10) + fx.pos * (parseInt(endRE[7], 10) - parseInt(startRE[7], 10))

          clipCss panel
    else
      clipCss panel

) jQuery
