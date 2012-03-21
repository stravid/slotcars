
#= require helpers/math/vector
#= require helpers/math/linked_list

Vector = helpers.math.Vector
LinkedList = helpers.math.LinkedList

class (namespace 'helpers.math').Path extends LinkedList

  totalLength: 0
  _lengthDirty: false

  @create: (parameters) ->
    parameters ?= { points: [] }
    new Path parameters.points

  constructor: (points) ->
    for point in points
      @push x: (parseFloat point.x, 10), y: (parseFloat point.y, 10), angle: (parseFloat point.angle, 10)

  clean: (parameters) ->
    next = @head

    while next? and @length > 3
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
      elements.push (@_getCleanPointFor current)
      next = current.next

    return elements

  asFixedLengthPointArray: ->
    @asPointArray().map (point) -> { x: (point.x.toFixed 2), y: (point.y.toFixed 2), angle: (point.angle.toFixed 2) }

  push: (point, shouldCalculateAngles) ->
    super point

    @_updateLengthFor point
    if @length > 1 then @_updateLengthFor (@getCircularNextOf point)
    @_lengthDirty = true

    if shouldCalculateAngles then @_calculateAnglesAroundPoint point

  insertBefore: (next, point) ->
    super next, point

    @_updateLengthFor point
    @_updateLengthFor next

    @_lengthDirty = true

  remove: (point) ->
    next = @getCircularNextOf point
    super point

    @_updateLengthFor next

    @_lengthDirty = true

  getTotalLength: ->
    if @_lengthDirty then @_updateLength()
    @totalLength

  getPointAtLength: (searchedLength) ->
    unless @length > 1
      return x: 0, y: 0, angle: 0

    if @_lengthDirty then @_updateLength()

    searchedLength = searchedLength % @getTotalLength()
    current = @head.next
    currentTotalLength = 0
    point = null

    while current?
      nextTotalLength = currentTotalLength + current.length

      if searchedLength is nextTotalLength
        point = @_getCleanPointFor current
        break
      else if searchedLength < nextTotalLength
        point = @_calculateIntermediatePointFor current, searchedLength - currentTotalLength
        break
      else
        currentTotalLength = nextTotalLength
        current = @getCircularNextOf current

    return point

  _getCleanPointFor: (point) ->
    x: point.x, y: point.y, angle: point.angle

  _calculateIntermediatePointFor: (point, factor) ->
    previous = (@getCircularPreviousOf point)
    vector = Vector.create from: previous, to: point
    length = vector.length()

    {
      x: previous.x + (vector.x / length * factor)
      y: previous.y + (vector.y / length * factor)
      angle: point.angle
    }

  _updateLength: ->
    @_updateTotalLength()
    @_lengthDirty = false

  _updateTotalLength: ->
    current = @head
    length = 0

    while current?
      length += current.length
      current = current.next

    @totalLength = length

  _updateLengthFor: (point) ->
    previous = @getCircularPreviousOf point

    vector = Vector.create from: previous, to: point
    point.length = vector.length()

  _pointShouldBeSplit: (point, parameters) ->
    next = @getCircularNextOf point
    currentVector = Vector.create from: point, to: next
    currentVector.length() > parameters.maxLength

  _pointShouldBeRemoved: (point, parameters) ->
    previous = @getCircularPreviousOf point
    next = @getCircularNextOf point

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
    previous = @getCircularPreviousOf point
    next = @getCircularNextOf point

    fromPrevious = Vector.create from: previous, to: point
    toNext = Vector.create from: point, to: next

    point.angle = fromPrevious.angleFrom toNext

  _splitPoint: (point) ->
    next = @getCircularNextOf point
    vector = Vector.create from: point, to: next

    @insertBefore next,
      x: point.x + vector.center().x
      y: point.y + vector.center().y
      angle: 0

  _calculateAnglesAroundPoint: (point) ->
    # only calculate angle if there are at least 3 points
    if @length > 2
      @_calculateAngleFor @getCircularPreviousOf point
      @_calculateAngleFor point
      @_calculateAngleFor @getCircularNextOf point