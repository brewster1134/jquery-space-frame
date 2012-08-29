
(function($) {
  return $(window).load(function() {
    $('.space-frame').spaceFrame();
    $('button#animate').click(function() {
      return $('.space-frame').spaceFrame('animate', [250, 250]);
    });
    $('button#refresh').click(function() {
      return $('.space-frame').spaceFrame('refresh');
    });
    return $('button#destroy').click(function() {
      return $('.space-frame').spaceFrame('destroy');
    });
  });
})(jQuery);
