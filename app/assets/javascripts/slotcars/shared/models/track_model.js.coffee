
#= require helpers/namespace
#= require embient/ember-data
#= require helpers/math/path

namespace 'slotcars.shared.models'

slotcars.shared.models.TrackModel = DS.Model.extend

  _path: null
  raphaelPath: 'M0,0Z'

  init: ->
    @_super()
    @_path = helpers.math.Path.create()

  addPathPoint: (point) ->
    @_path.push point, true
    @_updateRaphaelPath()

  getTotalLength: -> @_path.getTotalLength()

  getPointAtLength: (length) -> @_path.getPointAtLength length

  _updateRaphaelPath: ->
    pathString = "M"

    for point in @_path.asPointArray()
      pathString += "#{point.x},#{point.y}L"

    pathString = pathString.substr 0, pathString.length - 1
    pathString += "Z"

    @set 'raphaelPath', pathString