
#= require helpers/namespace
#= require helpers/math/path
#= require vendor/raphael

namespace 'helpers.math'

EMPTY_RAPHAEL_PATH_STRING = 'M0,0z'

Path = helpers.math.Path

RaphaelPath = helpers.math.RaphaelPath = Ember.Object.extend

  path: EMPTY_RAPHAEL_PATH_STRING
  _path: null
  _rasterizedPath: null

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

  rasterize: (rasterizationSize)->
    @_rasterizedPath = Path.create()

    path = @get 'path'
    totalLength = @get 'totalLength'

    # there is no optimization for curves vs. straight parts yet
    for length in [0..totalLength] by rasterizationSize
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