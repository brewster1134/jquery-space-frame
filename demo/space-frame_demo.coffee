$ ->
  $(window).load ->
    $('.space-frame').spaceframe
      position:
        x: 100
        y: 100

    $('button#animate').click ->
      randomWidth = Math.floor(Math.random()*501)
      randomHeight = Math.floor(Math.random()*376)

      $('.space-frame').each (i, el) ->
        $(el).spaceframe 'animate', randomWidth, randomHeight

    $('button#refresh').click ->
      $('.space-frame').each (i, el) ->
        $(el).spaceframe 'refresh'

    $('button#destroy').click ->
      $('.space-frame').each (i, el) ->
        $(el).spaceframe 'destroy'
