
#= require helpers/math/path
#= require vendor/raphael

EMPTY_RAPHAEL_PATH_STRING = 'M0,0z'

Path = helpers.math.Path

RaphaelPath = namespace('helpers.math').RaphaelPath = Ember.Object.extend

  path: EMPTY_RAPHAEL_PATH_STRING
  _path: null
  _rasterizedPath: null
  _cancelRasterization: false

  init: ->
    @set '_path', Path.create()

  addPoint: (point) ->
    @_path.push point, true
    @_updateCatmullRomPath()

  totalLength: (->
    Raphael.getTotalLength (@get 'path')
  ).property('path').cacheable()

  getPointAtLength: (length) ->
    if @_rasterizedPath?
      @_rasterizedPath.getPointAtLength length
    else
      Raphael.getPointAtLength (@get 'path'), length

  clear: ->
    @_path.clear()
    @_updateCatmullRomPath()

  clean: (parameters) ->
    @_path.clean parameters
    @_updateCatmullRomPath()

  rasterize: (parameters) ->
    if @_cancelRasterization
      @_cancelRasterization = false
      return @_rasterizedPath = null

    parameters ?= {}
    totalLength = parameters.totalLength ?= @get 'totalLength'

    # stop immediately if total length is zero
    return if totalLength <= 0

    stepSize = parameters.stepSize ?= 5
    pointsPerTick = parameters.pointsPerTick ?= 50
    currentStartLength = parameters.currentLength ?= 0

    # clamp next current length to total length
    currentEndLength = currentStartLength + pointsPerTick * stepSize
    currentEndLength = totalLength if currentEndLength > totalLength

    # create and fill rasterized path with points
    @_rasterizedPath ?= Path.create()
    @_rasterizePointsFromTo currentStartLength, currentEndLength, stepSize

    # tell progress handler the current rasterization length
    parameters.onProgress currentEndLength if parameters.onProgress

    nextCurrentStartLength = currentEndLength + stepSize

    # keep rasterizing if not finished yet
    if totalLength > nextCurrentStartLength
      parameters.currentLength = nextCurrentStartLength
      Ember.run.next => @rasterize parameters
    else
      parameters.onFinished() if parameters.onFinished?

  cancelRasterization: -> @_cancelRasterization = true

  _rasterizePointsFromTo: (start, end, stepSize) ->
    path = @get 'path'
    for length in [start..end] by stepSize
      @_rasterizedPath.push (Raphael.getPointAtLength path, length), true

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

# provide static class properties
RaphaelPath.reopenClass
  EMPTY_PATH_STRING: EMPTY_RAPHAEL_PATH_STRING