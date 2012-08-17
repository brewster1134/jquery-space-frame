$.fn.SpaceFrame = ->
  maxContentWidth = null
  maxContentHeight = null

  # INITIALIZE
  # elements
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

  # css
  scrubber.css
    position: 'absolute',
    zIndex: contents.length + 1
  contents.css
    position: 'absolute',
    overflow: 'hidden'
  @css
    position: 'relative'
    width: ->
      contents.each ->
        maxContentWidth = Math.max(maxContentWidth, $(@).width()) unless $(@).is(':empty')
      maxContentWidth
    height: ->
      contents.each ->
        maxContentHeight = Math.max(maxContentHeight, $(@).height()) unless $(@).is(':empty')
      maxContentHeight
  console.log @css('width')
  topPanels.css
    top: 0
  bottomPanels.css
    bottom: 0
  rightPanels.css
    right: 0
  leftPanels.css
    left: 0

  layerIndex = contents.length
  contents.each ->
    $(@).css
      zIndex: layerIndex
    layerIndex--

  clipPanels = ->
    # $('.testImg').stop().animate({'clip':'rect(0px 400px 300px 0px)'}, 1000)

  # events
  scrubber.on
    # iOS
    touchmove: (e) ->
      e.preventDefault()
      xPos = e.originalEvent.changedTouches[0].pageX
      yPos = e.originalEvent.changedTouches[0].pageY






  # FOR DEVELOPMENT
  scrubber.on
    click: ->
      $(@).trigger 'touchmove'
