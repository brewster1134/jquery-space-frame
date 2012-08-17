$.fn.SpaceFrame = ->
  ## ELEMENTS
  scrubber = @find('.space-scrubber')
  contents = @find('.space-content')

  # for panels 3 & 4, the bottom class is required
  panelOne = contents.filter('.left').not('.bottom')
  panelTwo = contents.filter('.right').not('.bottom')
  panelThree = contents.filter('.left.bottom')
  panelFour = contents.filter('.right.bottom')

  # helpers
  leftPanels = panelOne.add panelThree
  rightPanels = panelTwo.add panelFour
  topPanels = panelOne.add panelTwo
  bottomPanels = panelThree.add panelFour

  ## SETUP
  if bottomPanels.length == 0
    restrictAxis = 'x'
  else if rightPanels.length == 0
    restrictAxis = 'y'
  maxContentWidth = null
  maxContentHeight = null
  panelIndex = contents.length


  ## CSS
  @css
    width: ->
      contents.each ->
        maxContentWidth = Math.max(maxContentWidth, $(@).width()) unless $(@).is(':empty')
      maxContentWidth
    height: ->
      contents.each ->
        maxContentHeight = Math.max(maxContentHeight, $(@).height()) unless $(@).is(':empty')
      maxContentHeight
  topPanels.css
    top: 0
  bottomPanels.css
    bottom: 0
  rightPanels.css
    right: 0
  leftPanels.css
    left: 0
  scrubber.css
    marginTop: (scrubber.height() / 2) * -1,
    marginBottom: (scrubber.height() / 2) * -1,
    marginLeft: (scrubber.width() / 2) * -1,
    marginRight: (scrubber.width() / 2) * -1
  contents.each ->
    $(@).css
      zIndex: panelIndex
    panelIndex--


  ## ANIMATION
  # fontSize: 100 is need as filler css so values get returned
  clipPanels = (xPos, yPos) ->
    xPos = if restrictAxis == 'y' then maxContentWidth else xPos
    yPos = if restrictAxis == 'x' then maxContentHeight else yPos
    panelOne.stop().animate fontSize: 100,
      step: (now, fx) ->
        $(@).css
          clip: 'rect(0px, ' + xPos + 'px, ' + yPos + 'px, 0px)'
    panelTwo.stop().animate fontSize: 100,
      step: (now, fx) ->
        $(@).css
          clip: 'rect(0px, ' + maxContentWidth + 'px, ' + yPos + 'px, ' + xPos + 'px)'
    panelThree.stop().animate fontSize: 100,
      step: (now, fx) ->
        $(@).css
          clip: 'rect(' + yPos + 'px, ' + xPos + 'px, ' + maxContentHeight + 'px, 0px)'
    panelFour.stop().animate fontSize: 100,
      step: (now, fx) ->
        $(@).css
          clip: 'rect(' + yPos + 'px, ' + maxContentWidth + 'px, ' + maxContentHeight + 'px, ' + xPos + 'px)'


  ## EVENTS
  scrubber.draggable
    containment: 'parent',
    drag: (e, ui) ->
      clipPanels ui.position.left, ui.position.top
  # restict axis'
  scrubber.draggable 'option', 'axis', restrictAxis if restrictAxis

  # iOS
  scrubber.on
    touchmove: (e) ->
      e.preventDefault()
      xPos = e.originalEvent.changedTouches[0].pageX
      yPos = e.originalEvent.changedTouches[0].pageY
