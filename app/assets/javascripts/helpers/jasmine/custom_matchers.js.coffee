beforeEach ->
  @addMatchers
    toBeApproximatelyEqual: (expectedValue) ->
      (Math.abs expectedValue - @actual) < 0.001

    toBeApproximatelyZeroDegree: ->
      @actual < 0.001 or 179.99 < @actual