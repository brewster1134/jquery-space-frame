
(function($) {
  module("jQuery#awesome", {
    setup: function() {
      return this.elems = $("#qunit-fixture").children();
    }
  });
  test("is chainable", 1, function() {
    return strictEqual(this.elems.awesome(), this.elems, "should be chaninable");
  });
  test("is awesome", 1, function() {
    return strictEqual(this.elems.awesome().text(), "awesomeawesomeawesome", "should be thoroughly awesome");
  });
  module("jQuery.awesome");
  test("is awesome", 1, function() {
    return strictEqual($.awesome(), "awesome", "should be thoroughly awesome");
  });
  module(":awesome selector", {
    setup: function() {
      return this.elems = $("#qunit-fixture").children();
    }
  });
  return test("is awesome", 1, function() {
    return deepEqual(this.elems.filter(":awesome").get(), this.elems.last().get(), "knows awesome when it sees it");
  });
})(jQuery);
