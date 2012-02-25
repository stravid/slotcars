
#= require helpers/namespace
#= require helpers/math/vector
#= require helpers/math/linked_list

namespace 'helpers.math'

Vector = helpers.math.Vector
LinkedList = helpers.math.LinkedList

class helpers.math.Path extends LinkedList

  constructor: (points) ->
    for point in points
      @push x: point.x, y: point.y, angle: point.angle

  clean: (parameters) ->
    next = @head

    while next?
      current = next
      if @_pointShouldBeRemoved current, parameters
        next = if current.previous? then current.previous else current.next
        @remove current
        @_calculateAngleFor next

      else if @_pointShouldBeSplit current, parameters
        @_splitPoint current
        next = current

      else
        next = current.next

  asPointArray: ->
    next = @head
    elements = []

    while next?
      current = next
      elements.push x: current.x, y: current.y, angle: current.angle
      next = current.next

    return elements

  push: (point, shouldCalculateAngles) ->
    super point
    if shouldCalculateAngles then @_calculateAnglesAroundPoint point


  smooth: (angleThreshold) ->
    next = @head
    dirty = false

    while next?
      current = next
      next = current.next

      if current.angle > angleThreshold
        @_smoothPoint current
        dirty = true

    if dirty then @smooth angleThreshold

  _smoothPoint: (point) ->
    previous = @_getCircularPreviousOf point
    next = @_getCircularNextOf point

    vectorA = Vector.create from: previous, to: point
    vectorB = Vector.create from: point, to: next

    interpolatedA =
      x: previous.x + vectorA.center().x
      y: previous.y + vectorA.center().y

    interpolatedB =
      x: point.x + vectorB.center().x
      y: point.y + vectorB.center().y

    @remove point
    @insertBefore next, interpolatedA
    @insertBefore next, interpolatedB

    @_calculateAngleFor interpolatedA
    @_calculateAngleFor interpolatedB

  _pointShouldBeSplit: (point, parameters) ->
    next = @_getCircularNextOf point
    currentVector = Vector.create from: point, to: next
    currentVector.length() > parameters.maxLength

  _pointShouldBeRemoved: (point, parameters) ->
    previous = @_getCircularPreviousOf point
    next = @_getCircularNextOf point

    currentVector = Vector.create from: previous, to: point

    if point.angle < parameters.minAngle
      replacingVector = Vector.create from: previous, to: next
      return @_lengthIsOk replacingVector, parameters

    else if currentVector.length() < parameters.minLength then return true

    return false

  _lengthIsOk: (vector, parameters) ->
    length = vector.length()
    if length >= parameters.minLength and length <= parameters.maxLength
      return true

    return false

  _calculateAngleFor: (point) ->
    previous = @_getCircularPreviousOf point
    next = @_getCircularNextOf point

    fromPrevious = Vector.create from: previous, to: point
    toNext = Vector.create from: point, to: next

    point.angle = fromPrevious.angleFrom toNext

  _splitPoint: (point) ->
    next = @_getCircularNextOf point
    vector = Vector.create from: point, to: next

    @insertBefore next,
      x: point.x + vector.center().x
      y: point.y + vector.center().y
      angle: 0

  _getCircularPreviousOf: (point) ->
    if point is @head then @tail else point.previous

  _getCircularNextOf: (point) ->
    if point is @tail then @head else point.next

  _calculateAnglesAroundPoint: (point) ->
    # only calculate angle if there are at least 3 points
    if @length > 2
      @_calculateAngleFor @_getCircularPreviousOf point
      @_calculateAngleFor point
      @_calculateAngleFor @_getCircularNextOf point

  @create: (parameters) ->
    parameters ?= { points: [] }
    new Path parameters.points