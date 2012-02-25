
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

  _pointShouldBeSplit: (point, parameters) ->
    next = @_getCircluarNextOf point
    currentVector = Vector.create from: point, to: next
    currentVector.length() > parameters.maxLength

  _pointShouldBeRemoved: (point, parameters) ->
    previous = @_getCircluarPreviousOf point
    next = @_getCircluarNextOf point

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
    previous = @_getCircluarPreviousOf point
    next = @_getCircluarNextOf point

    fromPrevious = Vector.create from: previous, to: point
    toNext = Vector.create from: point, to: next

    point.angle = fromPrevious.angleFrom toNext

  _splitPoint: (point) ->
    next = @_getCircluarNextOf point
    vector = Vector.create from: point, to: next

    @insertBefore next,
      x: point.x + vector.center().x
      y: point.y + vector.center().y
      angle: 0

  _getCircluarPreviousOf: (point) ->
    if point is @head then @tail else point.previous

  _getCircluarNextOf: (point) ->
    if point is @tail then @head else point.next

  @create: (parameters) ->
    new Path parameters.points