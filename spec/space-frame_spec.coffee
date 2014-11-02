describe 'Space Frame', ->
  before ->
    $('.space-frame').spaceframe()

  describe '#animate', ->
    before ->
      $('.space-scrubber').css
        transitionProperty: 'none'
        left: 0
        top: 0
      $('.space-panel').css
        transitionProperty: 'none'
        clip: 'rect(10px 10px 10px 10px)'

      $('.space-frame').spaceframe 'animate', 100, 100, 0

    it 'should position the scrubber with animation properties', ->
      expect($('.space-scrubber').css('left')).to.equal '100px'
      expect($('.space-scrubber').css('top')).to.equal '100px'
      expect($('.space-scrubber').css('transitionProperty')).to.equal 'left, top'

    it 'should clip the panels with animation properties', ->
      expect($('.space-panel').eq(0).css('clip')).to.equal 'rect(100px 200px 200px 100px)'
      expect($('.space-panel').eq(0).css('transitionProperty')).to.equal 'clip'

  describe '#refresh', ->
    before ->
      $('.space-scrubber').css
        left: 10
        top: 10

      $('.space-panel').css
        clip: 'rect(10px 10px 10px 10px)'

      $('.space-frame').spaceframe 'refresh'

    it 'should position the scrubber with animation properties', ->
      expect($('.space-scrubber').css('left')).to.equal '0px'
      expect($('.space-scrubber').css('top')).to.equal '0px'

    it 'should clip the panels with animation properties', ->
      expect($('.space-panel').eq(0).css('clip')).to.equal 'rect(0px 200px 200px 0px)'

  describe '#destroy', ->
    before ->
      $('.space-scrubber').css
        left: 10
        top: 10

      $('.space-panel').css
        clip: 'rect(10px 10px 10px 10px)'

      $('.space-frame').spaceframe 'destroy'

    it 'should hide the scrubber', ->
      expect($('.space-scrubber').is(':visible')).to.equal false

    it 'should hide all but the 1st panel', ->
      expect($('.space-panel').eq(0).is(':visible')).to.equal true
      expect($('.space-panel').eq(1).is(':visible')).to.equal false
      expect($('.space-panel').eq(2).is(':visible')).to.equal false
      expect($('.space-panel').eq(3).is(':visible')).to.equal false
