
#= require helpers/namespace
#= require embient/ember-data
#= require slotcars/shared/models/model_store
#= require helpers/math/path

namespace 'slotcars.shared.models'

EMPTY_RAPHAEL_PATH = 'M0,0Z'

slotcars.shared.models.TrackModel = DS.Model.extend

  _path: null
  raphaelPath: EMPTY_RAPHAEL_PATH

  init: ->
    @_super()
    @_path = helpers.math.Path.create()

  addPathPoint: (point) ->
    @_path.push point, true
    @_updateRaphaelPath()

  getTotalLength: -> @_path.getTotalLength()

  getPointAtLength: (length) -> @_path.getPointAtLength length

  clearPath: ->
    @_path.clear()
    @set 'raphaelPath', EMPTY_RAPHAEL_PATH

  cleanPath: ->
    @_path.clean minAngle: 10, minLength: 10, maxLength: 30
    @_updateRaphaelPath()

  _updateRaphaelPath: ->
    pathString = "M"

    for point in @_path.asPointArray()
      pathString += "#{point.x},#{point.y}L"

    pathString = pathString.substr 0, pathString.length - 1
    pathString += "Z"

    @set 'raphaelPath', pathString