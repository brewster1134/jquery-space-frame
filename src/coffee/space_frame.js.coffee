$.fn.SpaceFrame = ->
  @each ->
    ## ELEMENTS
    scrubber = $(@).find('.space-scrubber')
    contents = $(@).find('.space-panel')

    # panelOne = contents.filter('.left, .top').not('.bottom')
    # panelTwo = contents.filter('.right, .top').not('.bottom')
    # panelThree = contents.filter('.left.bottom')
    # panelFour = contents.filter('.right.bottom')
    panelOne = $(contents.get(0))
    panelTwo = $(contents.get(1))
    panelThree = $(contents.get(2))
    panelFour = $(contents.get(3))


    ## SETUP
    if $(@).hasClass 'x'
      console.warn 'There should only be 2 panels for a x axis space frame!' if contents.length != 2
      restrictAxis = 'x'
    else if $(@).hasClass 'y'
      console.warn 'There should only be 2 panels for a y axis space frame!' if contents.length != 2
      restrictAxis = 'y'
    maxContentWidth = null
    maxContentHeight = null
    panelIndex = contents.length

    # helpers
    leftPanels = panelOne.add panelThree
    rightPanels = panelTwo.add panelFour
    topPanels = panelOne.add panelTwo
    bottomPanels = panelThree.add panelFour


    ## CSS
    $(@).css
      width: ->
        contents.each ->
          maxContentWidth = Math.max(maxContentWidth, $(@).width()) unless $(@).is(':empty')
        maxContentWidth
      height: ->
        contents.each ->
          maxContentHeight = Math.max(maxContentHeight, $(@).height()) unless $(@).is(':empty')
        maxContentHeight
    leftPanels.css
      left: 0
    rightPanels.css
      right: 0
    topPanels.css
      top: 0
    bottomPanels.css
      bottom: 0
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
      panelTwo = panelFour if restrictAxis == 'y' # need to treat panelTwo like bottom right panel when on y axis
      xPos = if restrictAxis == 'y' then maxContentWidth else xPos
      yPos = if restrictAxis == 'x' then maxContentHeight else yPos
      panelOne.stop().animate fontSize: 100,
        step: (now, fx) ->
          $(@).css
            clip: 'rect(0px, ' + xPos + 'px, ' + yPos + 'px, 0px)'
        , 10000
      panelTwo.stop().animate fontSize: 100,
        step: (now, fx) ->
          $(@).css
            clip: 'rect(0px, ' + maxContentWidth + 'px, ' + yPos + 'px, ' + xPos + 'px)'
        , 10000
      panelThree.stop().animate fontSize: 100,
        step: (now, fx) ->
          $(@).css
            clip: 'rect(' + yPos + 'px, ' + xPos + 'px, ' + maxContentHeight + 'px, 0px)'
        , 10000
      panelFour.stop().animate fontSize: 100,
        step: (now, fx) ->
          $(@).css
            clip: 'rect(' + yPos + 'px, ' + maxContentWidth + 'px, ' + maxContentHeight + 'px, ' + xPos + 'px)'
        , 10000


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

    clipPanels 250, 250 # TODO: not animating?
