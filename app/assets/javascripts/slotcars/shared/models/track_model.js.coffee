
#= require helpers/namespace
#= require embient/ember-data
#= require slotcars/shared/models/model_store
#= require helpers/math/path
#= require vendor/raphael

namespace 'slotcars.shared.models'

EMPTY_RAPHAEL_PATH = 'M0,0z'

Path = helpers.math.Path

slotcars.shared.models.TrackModel = DS.Model.extend

  _path: null
  _rasterizedPath: null
  _shouldUpdateRasterizedPath: false
  raphaelPath: EMPTY_RAPHAEL_PATH

  init: ->
    @_super()
    @_path = Path.create()

  addPathPoint: (point) ->
    @_path.push point, true
    @_updateRaphaelPath()

  getTotalLength: ->
    unless @_rasterizedPath?
      @_path.getTotalLength()
    else
      @_rasterizedPath.getTotalLength()

  getPointAtLength: (length) ->
    unless @_rasterizedPath?
      @_path.getPointAtLength length
    else
      @_rasterizedPath.getPointAtLength length

  clearPath: ->
    @_path.clear()
    @set 'raphaelPath', EMPTY_RAPHAEL_PATH

  cleanPath: ->
    @_path.clean minAngle: 10, minLength: 100, maxLength: 400
    @_shouldUpdateRasterizedPath = true
    @_updateRaphaelPath()

  playRoute: (->
    clientId = @get('clientId')
    "play/#{clientId}"
  ).property 'clientId'

  # Generates catmull-rom paths for raphel with format: x1 y1 (x y)+
  # which results in pathes like: M0,0R,1,0,3,2,4,5z
  _updateRaphaelPath: ->

    # catmull-rom paths are not valid with less points than 3
    if @_path.length < 3
      @set 'raphaelPath', EMPTY_RAPHAEL_PATH
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

    @set 'raphaelPath', pathString

  _updateRasterizedPath: (->
    return unless @_shouldUpdateRasterizedPath

    # defer rasterization since it is time costly and would block other operations
    Ember.run.later (=> @_rasterizeRaphaelPath()), 10

    @_shouldUpdateRasterizedPath = false

  ).observes 'raphaelPath'

  _rasterizeRaphaelPath: ->
    @_rasterizedPath = Path.create()
    path = @get 'raphaelPath'
    totalLength = (Math.round Raphael.getTotalLength path)

    # there is no optimization for curves vs. straight parts yet
    for length in [0..totalLength] by 5
      @_rasterizedPath.push (Raphael.getPointAtLength path, length), true