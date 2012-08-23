#global QUnit:false, module:false, test:false, asyncTest:false, expect:false
#global start:false, stop:false ok:false, equal:false, notEqual:false, deepEqual:false
#global notDeepEqual:false, strictEqual:false, notStrictEqual:false, raises:false

(($) ->
  #
  #    ======== A Handy Little QUnit Reference ========
  #    http://docs.jquery.com/QUnit
  #
  #    Test methods:
  #      expect(numAssertions)
  #      stop(increment)
  #      start(decrement)
  #    Test assertions:
  #      ok(value, [message])
  #      equal(actual, expected, [message])
  #      notEqual(actual, expected, [message])
  #      deepEqual(actual, expected, [message])
  #      notDeepEqual(actual, expected, [message])
  #      strictEqual(actual, expected, [message])
  #      notStrictEqual(actual, expected, [message])
  #      raises(block, [expected], [message])
  #
  module "jQuery#awesome",
    setup: ->
      @elems = $("#qunit-fixture").children()

  test "is chainable", 1, ->

    # Not a bad test to run on collection methods.
    strictEqual @elems.awesome(), @elems, "should be chaninable"

  test "is awesome", 1, ->
    strictEqual @elems.awesome().text(), "awesomeawesomeawesome", "should be thoroughly awesome"

  module "jQuery.awesome"
  test "is awesome", 1, ->
    strictEqual $.awesome(), "awesome", "should be thoroughly awesome"

  module ":awesome selector",
    setup: ->
      @elems = $("#qunit-fixture").children()

  test "is awesome", 1, ->

    # Use deepEqual & .get() when comparing jQuery objects.
    deepEqual @elems.filter(":awesome").get(), @elems.last().get(), "knows awesome when it sees it"

) jQuery
