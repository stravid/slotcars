beforeEach ->
  @addMatchers
    toBeApproximatelyEqual: (expectedValue) ->
      (Math.abs expectedValue - @actual) < 0.001

    toBeApproximatelyZeroDegree: ->
      @actual < 0.001 or 179.99 < @actual

    toHaveBeenCalledWithAnObjectLike: (expectedObject) ->
      @env.equals_(@actual.args[0][0], expectedObject);