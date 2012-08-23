(($) ->
  $(window).load ->
    $('.space-frame').spaceFrame()

    $('button#animate').click ->
      $('.space-frame').spaceFrame('animate', [250, 250])

    $('button#refresh').click ->
      $('.space-frame').spaceFrame('refresh')

    $('button#destroy').click ->
      $('.space-frame').spaceFrame('destroy')
) jQuery
