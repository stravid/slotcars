EMPTY_RAPHAEL_PATH_STRING = 'M0,0z'

Shared.RaphaelPath = Ember.Object.extend

  path: EMPTY_RAPHAEL_PATH_STRING
  _path: null
  _rasterizedPath: null

  init: ->
    @set '_path', Shared.Path.create()
    @_rasterizedPath = Shared.Path.create()

  addPoint: (point) ->
    @_path.push point, true
    @_updateCatmullRomPath()

  totalLength: (->
    Raphael.getTotalLength (@get 'path')
  ).property('path').cacheable()

  getPointAtLength: (length) ->
    if @_rasterizedPath.length > 0
      @_rasterizedPath.getPointAtLength length
    else
      Raphael.getPointAtLength (@get 'path'), length

  getPathPointArray: -> @_path.asPointArray()

  clear: ->
    @_path.clear()
    @_updateCatmullRomPath()

  clean: (parameters) ->
    @_path.clean parameters
    @_updateCatmullRomPath()

  rasterize: (parameters) ->
    totalLength = @get 'totalLength'

    parameters.currentLength ?= 0
    currentStartLength = parameters.currentLength

    # clamp next current length to total length
    currentEndLength = currentStartLength + parameters.lengthPerRasterizingPhase
    currentEndLength = totalLength if currentEndLength > totalLength

    # fill rasterized path with points
    @_rasterizePointsFromTo currentStartLength,
                            currentEndLength,
                            parameters.minimumLengthPerPoint,
                            parameters.lengthLimitForAngleFactor

    # tell progress handler the current rasterization length
    parameters.onProgress currentEndLength if parameters.onProgress

    nextCurrentStartLength = currentEndLength

    # keep rasterizing if not finished yet
    if totalLength > nextCurrentStartLength
      parameters.currentLength = nextCurrentStartLength
      Ember.run.next => @rasterize parameters
    else
      @_cleanRasterizedPath parameters.minimumAngle
      parameters.onFinished() if parameters.onFinished?

  _rasterizePointsFromTo: (startLength, endLength, minimumLengthPerPoint, lengthLimitForAngleFactor) ->
    path = @get 'path'
    currentLength = startLength

    while currentLength < endLength
      point = Raphael.getPointAtLength path, currentLength

      @_rasterizedPath.push point, true

      # look at previous point and consider its angle for next length
      lengthRelativeToCurrentAngle = minimumLengthPerPoint
      previousPoint = @_rasterizedPath.tail.previous

      if previousPoint and previousPoint.angle > 0
        # low angles (0 - 0.9) increase the length by angleFactor
        angleFactor = Math.pow previousPoint.angle, 2
        # lengthLimitForAngleFactor: very low angles would result in (too) high length distances
        lengthRelativeToCurrentAngle = (Math.min lengthLimitForAngleFactor, minimumLengthPerPoint + 1 / angleFactor)

      currentLength += lengthRelativeToCurrentAngle

  _cleanRasterizedPath: (minimumAngle) ->
    currentPoint = @_rasterizedPath.head

    while currentPoint?
      @_rasterizedPath.remove currentPoint if currentPoint.angle < minimumAngle
      currentPoint = currentPoint.next

  # Generates catmull-rom paths for raphel with format: x1 y1 (x y)+
  # which results in pathes like: M0,0R,1,0,3,2,4,5z
  _updateCatmullRomPath: ->
    # catmull-rom paths are not valid with less points than 3
    if @_path.length < 3
      @set 'path', EMPTY_RAPHAEL_PATH_STRING
      return

    pathString = "M"
    firstTime = true

    for point in @_path.asPointArray()
      pathString += "#{point.x},#{point.y}"

      if firstTime
        pathString += "R"
      else
        pathString += ","

      firstTime = false

    # remove last comma
    pathString = pathString.substr 0, pathString.length - 1
    pathString += "z"

    @set 'path', pathString

  setRaphaelPath: (path) -> @set 'path', path

  setRasterizedPath: (points) -> @set '_rasterizedPath', Shared.Path.create points: points

  setLinkedPath: (points) ->
    @_path.destroy()
    @_rasterizedPath.destroy() if @_rasterizedPath?

    @set '_path', Shared.Path.create points: points
    @set '_rasterizedPath', Shared.Path.create()

    @_updateCatmullRomPath()

# provide static class properties
Shared.RaphaelPath.reopenClass
  EMPTY_PATH_STRING: EMPTY_RAPHAEL_PATH_STRING